import 'edit_profile_model.dart';

class TeamMemberModel {
  final String id;
  final String name;
  final String role;
  final String imageUrl;
  final int matches;
  final int level;

  // EditProfile fields
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String birthday;
  final String gender;

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.matches,
    required this.level,
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.phone = "",
    this.birthday = "",
    this.gender = "",
  });
}


// Dummy member data (Future API)
final TeamMemberModel dummyMember = TeamMemberModel(
  id: "1",
  name: "Ken Adams",
  role: "Batsman",
  imageUrl: "assets/images/profile.png",
  matches: 0,
  level: 1,
);

