import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/init/app_initializer.dart';
import 'package:karlfive/core/theme/app_theme.dart';
import 'package:karlfive/features/auth/presentation/screens/splash_screen.dart';
import 'package:karlfive/features/home/presentation/screens/home_screen.dart';
import 'package:karlfive/features/join_league/presentation/screens/form_screen/join_league_screen.dart';
import 'package:karlfive/features/payment/presentation/screens/confirm_payment_screen.dart';
import 'package:karlfive/features/payment/presentation/screens/payment_font_screen.dart';
import 'package:karlfive/features/payment/presentation/screens/payment_screen.dart';
import 'package:karlfive/features/team_members_profile/models/team_member_model.dart';
import 'package:karlfive/features/team_members_profile/presentation/screens/profile_info_screen.dart';

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
      // home: SplashScreen(),
      home: ConfirmPaymentScreen(),
      debugShowCheckedModeBanner: true,
    );
  }
}
