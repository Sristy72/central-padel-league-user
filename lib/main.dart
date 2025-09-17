import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/profile_info_screen.dart';
import 'features/team_members_profile/models/team_member_model.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/profile_info_screen.dart';
import 'package:karlfive/features/team_members_profile/models/team_member_model.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Demo',
      theme: ThemeData.dark(), // dark theme
      home: ProfileInfoScreen(member: dummyMember),
    );
  }
}
