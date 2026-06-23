import '../models/admin_account.dart';
import '../models/app_transaction.dart';
import '../models/chat_message.dart';
import '../models/citizen_account.dart';
import '../models/corporate_account.dart';
import '../models/enums.dart';

class LocalDatabaseService {
  LocalDatabaseService._();
  static final LocalDatabaseService instance = LocalDatabaseService._();

  final Map<String, CitizenAccount> citizens = {};
  final Map<String, CorporateAccount> corporates = {};
  final List<AppTransaction> transactions = [];
  final List<ChatMessage> messages = [];

  AdminAccount admin = AdminAccount(balance: 0, createdAt: DateTime.now());

  String? persistedSessionAccountId;
  bool persistedCorporateMode = false;

  bool _seeded = false;

  void resetWithSeedData() {
    citizens.clear();
    corporates.clear();
    transactions.clear();
    messages.clear();
    admin = AdminAccount(balance: 0, createdAt: DateTime.now());
    persistedSessionAccountId = null;
    persistedCorporateMode = false;
    _seeded = false;
    seedIfNeeded();
  }

  void seedIfNeeded() {
    if (_seeded) return;
    _seeded = true;

    citizens['100001'] = CitizenAccount(
      id: '100001',
      password: 'password123',
      name: 'Alex Carter',
      city: 'Jefferson City',
      programType: ProgramType.mbs,
      partyAffiliation: PartyAffiliation.federalist,
      profilePicture: null,
      balance: 500,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isProfileComplete: true,
    );

    citizens['100002'] = CitizenAccount(
      id: '100002',
      password: 'password123',
      name: 'Jordan Lee',
      city: 'Springfield',
      programType: ProgramType.mgs,
      partyAffiliation: PartyAffiliation.nationalist,
      profilePicture: null,
      balance: 420,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isProfileComplete: true,
    );

    citizens['100003'] = CitizenAccount(
      id: '100003',
      password: 'password123',
      name: 'Sam Morgan',
      city: 'Columbia',
      programType: ProgramType.mbs,
      partyAffiliation: PartyAffiliation.nationalist,
      profilePicture: null,
      balance: 300,
      createdAt: DateTime.now(),
      isProfileComplete: false,
    );

    corporates['C-NEWS'] = CorporateAccount(
      id: 'C-NEWS',
      ownerCitizenId: '100001',
      balance: 1000,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      corporateName: 'Federalist Daily',
    );

    corporates['C-CAFE'] = CorporateAccount(
      id: 'C-CAFE',
      ownerCitizenId: '100002',
      balance: 900,
      createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      corporateName: 'Nationalist Cafe',
    );
  }
}
