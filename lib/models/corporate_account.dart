import 'account.dart';
import 'enums.dart';

class CorporateAccount extends Account {
  CorporateAccount({
    required super.id,
    required this.ownerCitizenId,
    required super.balance,
    required super.createdAt,
    required this.corporateName,
  }) : super(accountType: AccountType.corporate, displayName: corporateName);

  final String ownerCitizenId;
  final String corporateName;

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'ownerCitizenId': ownerCitizenId,
        'corporateName': corporateName,
      };
}
