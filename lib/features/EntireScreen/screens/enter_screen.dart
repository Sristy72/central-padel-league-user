import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/common/widgets/form_error_message.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import '../controller/enter_controller.dart';

class EnterScreen extends StatelessWidget {
  const EnterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EnterController());

    return AppScaffold(
      body: Stack(
        children: [
          // Full-screen background image
          SizedBox.expand(
            child: Image.asset(
              AppImages.entireScreen,
              fit: BoxFit.cover, // covers the whole screen
            ),
          ),

          // Overlay content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error message
                    Obx(
                      () => FormErrorMessage(
                        message: controller.errorMessage.value,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Title
                    Text(
                      "Your Padel Updates, Always On Time",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.start,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Stay updated with match schedules, live \n scores, and league standings so you’re always \n in the loop.",
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),

                    const SizedBox(height: 32),

                    // Continue Button
                    Obx(
                      () => PrimaryButton(
                        isLoading: controller.isLoading.value,
                        onPressed: controller.onContinue,
                        text: "Continue",
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
