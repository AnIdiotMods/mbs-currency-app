import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/account.dart';
import '../models/admin_account.dart';
import '../models/app_transaction.dart';
import '../models/chat_message.dart';
import '../models/citizen_account.dart';
import '../models/corporate_account.dart';
import '../models/enums.dart';
import '../services/local_database_service.dart';

class AppState extends ChangeNotifier {
  AppState({LocalDatabaseService? database})
      : _db = database ?? LocalDatabaseService.instance {
    _db.seedIfNeeded();
    if (_db.persistedSessionAccountId != null) {
      _currentUserId = _db.persistedSessionAccountId;
      _useCorporateMode = _db.persistedCorporateMode;
    }
  }

  final LocalDatabaseService _db;
  final Uuid _uuid = const Uuid();

  String? _currentUserId;
  bool _useCorporateMode = false;

  bool get isAuthenticated => _currentUserId != null;
  bool get isAdmin => _currentUserId == AdminAccount.adminId;
  String? get currentUserId => _currentUserId;

  AdminAccount get admin => _db.admin;

  CitizenAccount? get currentCitizen => _currentUserId == null || isAdmin
      ? null
      : _db.citizens[_currentUserId!];

  CorporateAccount? get activeCorporateAccount {
    if (!_useCorporateMode || currentCitizen == null) return null;
    final ownerId = currentCitizen!.id;
    try {
      return _db.corporates.values
          .firstWhere((corp) => corp.ownerCitizenId == ownerId);
    } catch (_) {
      return null;
    }
  }

  CorporateAccount? get ownedCorporateAccount {
    if (currentCitizen == null) return null;
    final ownerId = currentCitizen!.id;
    try {
      return _db.corporates.values
          .firstWhere((corp) => corp.ownerCitizenId == ownerId);
    } catch (_) {
      return null;
    }
  }

  bool get useCorporateMode => _useCorporateMode;

  List<CitizenAccount> get citizens =>
      _db.citizens.values.toList()..sort((a, b) => a.id.compareTo(b.id));

  List<CorporateAccount> get corporates =>
      _db.corporates.values.toList()..sort((a, b) => a.id.compareTo(b.id));

  List<AppTransaction> get transactions =>
      _db.transactions.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  List<ChatMessage> get messages =>
      _db.messages.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  bool login({required String id, required String password}) {
    if (id == AdminAccount.adminId && password == AdminAccount.adminPassword) {
      _currentUserId = id;
      _db.persistedSessionAccountId = id;
      notifyListeners();
      return true;
    }

    final citizen = _db.citizens[id];
    if (citizen == null || citizen.password != password) {
      return false;
    }

    _currentUserId = id;
    _db.persistedSessionAccountId = id;
    notifyListeners();
    return true;
  }

  bool registerAccount({
    required String id,
    required String password,
  }) {
    // Check if account already exists
    if (_db.citizens.containsKey(id)) {
      return false;
    }

    // Create new account with provided password
    _db.citizens[id] = CitizenAccount(
      id: id,
      password: password,
      name: '',
      city: '',
      programType: ProgramType.mbs,
      partyAffiliation: PartyAffiliation.federalist,
      profilePicture: null,
      balance: 0,
      createdAt: DateTime.now(),
      isProfileComplete: false,
    );

    // Auto-login after registration
    _currentUserId = id;
    _db.persistedSessionAccountId = id;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUserId = null;
    _useCorporateMode = false;
    _db.persistedSessionAccountId = null;
    _db.persistedCorporateMode = false;
    notifyListeners();
  }

  void setCorporateMode(bool enabled) {
    if (enabled && ownedCorporateAccount == null) return;
    _useCorporateMode = enabled;
    _db.persistedCorporateMode = enabled;
    notifyListeners();
  }

  void completeProfile({
    required String name,
    required String city,
    required ProgramType programType,
    required PartyAffiliation partyAffiliation,
    String? profilePicture,
  }) {
    final citizen = currentCitizen;
    if (citizen == null) return;

    citizen
      ..name = name.trim()
      ..city = city.trim()
      ..programType = programType
      ..partyAffiliation = partyAffiliation
      ..profilePicture = profilePicture
      ..isProfileComplete = true;
    notifyListeners();
  }

  List<CitizenAccount> findCitizens(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return citizens;
    return citizens
        .where((c) => c.id.toLowerCase().contains(q) || c.name.toLowerCase().contains(q))
        .toList();
  }

  Account? findAnyAccount(String id) {
    if (id == AdminAccount.adminId) return admin;
    return _db.citizens[id] ?? _db.corporates[id];
  }

  String sourceAccountIdForCurrentUser() {
    if (isAdmin) return AdminAccount.adminId;
    final citizen = currentCitizen;
    if (citizen == null) return '';
    return activeCorporateAccount?.id ?? citizen.id;
  }

  AppTransaction transferFromCurrentUser({
    required String recipientId,
    required double amount,
    TransactionType type = TransactionType.transfer,
  }) {
    final sourceId = sourceAccountIdForCurrentUser();
    return executeTransfer(
      fromId: sourceId,
      toId: recipientId,
      amount: amount,
      type: type,
    );
  }

  AppTransaction executeTransfer({
    required String fromId,
    required String toId,
    required double amount,
    required TransactionType type,
  }) {
    final normalizedAmount = _normalizeCurrency(amount);
    final source = findAnyAccount(fromId);
    final recipient = findAnyAccount(toId);

    if (source == null || recipient == null || normalizedAmount <= 0 || fromId == toId) {
      return _recordFailure(
        fromId: fromId,
        toId: toId,
        amount: normalizedAmount,
        type: type,
        reason: 'Invalid transfer request.',
      );
    }

    final isCorporateTransfer = source.accountType == AccountType.corporate;
    final fee = isCorporateTransfer ? _normalizeCurrency(normalizedAmount * 0.05) : 0.0;
    final totalDeduction = _normalizeCurrency(normalizedAmount + fee);

    if (source.balance < totalDeduction) {
      return _recordFailure(
        fromId: fromId,
        toId: toId,
        amount: normalizedAmount,
        type: type,
        reason: 'Insufficient funds for amount and corporate fee.',
        feeAmount: fee,
      );
    }

    // Single-threaded in-memory mutation block for principal and fee routing.
    source.balance = _normalizeCurrency(source.balance - totalDeduction);
    recipient.balance = _normalizeCurrency(recipient.balance + normalizedAmount);
    if (fee > 0) {
      _db.admin.balance = _normalizeCurrency(_db.admin.balance + fee);
    }

    final transaction = AppTransaction(
      id: _uuid.v4(),
      fromAccount: fromId,
      toAccount: toId,
      amount: normalizedAmount,
      timestamp: DateTime.now(),
      type: type,
      status: TransactionStatus.completed,
      feeAmount: fee,
    );

    _db.transactions.add(transaction);
    notifyListeners();
    return transaction;
  }

  AppTransaction adminAdjustBalance({
    required String accountId,
    required double delta,
  }) {
    if (!isAdmin) {
      return _recordFailure(
        fromId: AdminAccount.adminId,
        toId: accountId,
        amount: delta,
        type: TransactionType.adminAdjustment,
        reason: 'Only admin can adjust balances.',
      );
    }

    final target = findAnyAccount(accountId);
    if (target == null) {
      return _recordFailure(
        fromId: AdminAccount.adminId,
        toId: accountId,
        amount: delta,
        type: TransactionType.adminAdjustment,
        reason: 'Target account not found.',
      );
    }

    final normalizedDelta = _normalizeCurrency(delta);
    final nextBalance = _normalizeCurrency(target.balance + normalizedDelta);
    if (nextBalance < 0) {
      return _recordFailure(
        fromId: AdminAccount.adminId,
        toId: accountId,
        amount: normalizedDelta,
        type: TransactionType.adminAdjustment,
        reason: 'Adjustment would make balance negative.',
      );
    }

    target.balance = nextBalance;
    final transaction = AppTransaction(
      id: _uuid.v4(),
      fromAccount: AdminAccount.adminId,
      toAccount: accountId,
      amount: normalizedDelta,
      timestamp: DateTime.now(),
      type: TransactionType.adminAdjustment,
      status: TransactionStatus.completed,
    );
    _db.transactions.add(transaction);
    notifyListeners();
    return transaction;
  }

  void sendMessage({required String recipientId, required String body}) {
    final sender = currentUserId;
    if (sender == null || body.trim().isEmpty || findAnyAccount(recipientId) == null) {
      return;
    }

    _db.messages.add(ChatMessage(
      id: _uuid.v4(),
      senderId: sender,
      recipientId: recipientId,
      body: body.trim(),
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  List<ChatMessage> chatWith(String otherId) {
    final me = currentUserId;
    if (me == null) return [];
    return messages
        .where((m) =>
            (m.senderId == me && m.recipientId == otherId) ||
            (m.senderId == otherId && m.recipientId == me))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  AppTransaction _recordFailure({
    required String fromId,
    required String toId,
    required double amount,
    required TransactionType type,
    required String reason,
    double feeAmount = 0,
  }) {
    final transaction = AppTransaction(
      id: _uuid.v4(),
      fromAccount: fromId,
      toAccount: toId,
      amount: _normalizeCurrency(max(0, amount)),
      timestamp: DateTime.now(),
      type: type,
      status: TransactionStatus.failed,
      feeAmount: _normalizeCurrency(feeAmount),
      failureReason: reason,
    );
    _db.transactions.add(transaction);
    notifyListeners();
    return transaction;
  }

  double _normalizeCurrency(double value) =>
      double.parse(value.toStringAsFixed(2));
}
