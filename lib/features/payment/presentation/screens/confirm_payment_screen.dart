import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/home/presentation/screens/home_screen.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  const ConfirmPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/teenyicons_tick-circle-solid.png",
              height: 100,
              width: 100,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Team Successfully Added!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xffF2F2F2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Your team is now part of the league—get ready \nto play and shine!",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xfff2f2f2),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.to(() => HomeScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff2B7FD0),
              padding: EdgeInsets.symmetric(horizontal: 21, vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            child: Text(
              "Return To Dashboard",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xffF2F2F2),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
