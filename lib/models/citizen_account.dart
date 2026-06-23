import 'account.dart';
import 'enums.dart';

class CitizenAccount extends Account {
  CitizenAccount({
    required super.id,
    this.password,
    required this.name,
    required this.city,
    required this.programType,
    required this.partyAffiliation,
    required this.profilePicture,
    required super.balance,
    required super.createdAt,
    required this.isProfileComplete,
  }) : super(accountType: AccountType.personal, displayName: name);

  final String? password;
  String name;
  String city;
  ProgramType programType;
  PartyAffiliation partyAffiliation;
  String? profilePicture;
  bool isProfileComplete;

  bool ownsCorporate(Iterable<String> ownerCorporateIds) =>
      ownerCorporateIds.contains(id);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'password': password,
        'name': name,
        'city': city,
        'programType': programType.name,
        'partyAffiliation': partyAffiliation.name,
        'profilePicture': profilePicture,
        'isProfileComplete': isProfileComplete,
      };
}
