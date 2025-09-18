import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_theme.dart';

import 'package:karlfive/features/EntireScreen/controller/Profile_info_next_controller.dart';
import 'package:karlfive/features/EntireScreen/screens/enter_screen.dart';
import 'package:karlfive/features/EntireScreen/screens/profile_info_next.dart';
import 'package:karlfive/features/EntireScreen/screens/profile_photo_upload_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:karlfive/features/auth/presentation/screens/splash_screen.dart';

import 'core/init/app_initializer.dart';
import 'features/privacy policy /presentation/screens/privacypolicy_screen.dart';

import 'package:karlfive/features/home/presentation/screens/home_screen.dart';
import 'package:karlfive/features/payment/presentation/screens/payment_screen.dart';
import 'package:karlfive/features/team_members_profile/models/team_member_model.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/profile_info_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KarlFive',
      theme: AppTheme.dark,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
