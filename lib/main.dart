import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_theme.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';
import 'package:karlfive/features/join_league/presentation/screens/form_screen/join_league_screen.dart';
import 'package:karlfive/features/join_league/presentation/widgets/league_dropdown.dart';
import 'core/init/app_initializer.dart';
import 'features/join_league/presentation/screens/otp_screen/otp_verification_screen.dart';

void main() async {
  await AppInitializer.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KarlFive',
      theme: AppTheme.dark,
      home: JoinLeagueScreen(),
    );
  }
}
