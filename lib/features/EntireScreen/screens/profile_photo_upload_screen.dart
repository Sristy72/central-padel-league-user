import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:karlfive/features/EntireScreen/controller/progress_page_controller.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/EntireScreen/widgets/custom_text_field_widget.dart';

class PhotoUploadScreen extends StatelessWidget {
  PhotoUploadScreen({super.key});

  final progressController = Get.put(ProgressPageController());
  final pickedImage = Rx<File?>(null);
  final mobileController = TextEditingController();

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      pickedImage.value = File(image.path);
      progressController.updateProgress(1.0); // ✅ full progress after upload
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Obx(() {
                return Container(
                  height: 7,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(46),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(46),
                    child: LinearProgressIndicator(
                      value: progressController.currentPage.value,
                      color: Colors.green,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 50),

            // Upload container
            Container(
              height: 304,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                return GestureDetector(
                  onTap: pickImage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 59,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: pickedImage.value != null
                            ? FileImage(pickedImage.value!)
                            : null,
                        child: pickedImage.value == null
                            ? Image.asset(
                                "assets/images/person.png",
                                width: 40,
                                height: 40,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Upload text
                      const Text(
                        "Upload your photo",
                        style: TextStyle(
                          color: AppColors.textBoxColor,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Mobile Number Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Mobile",
                            style: TextStyle(
                              color: AppColors.textBoxColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                            hintText: "Write here",
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),

            const Spacer(),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      progressController.updateProgress(0.25);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryText,
                      foregroundColor: AppColors.textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Back"),
                  ),

                  // Next button
                  ElevatedButton(
                    onPressed: () {
                      if (pickedImage.value == null) {
                        Get.snackbar(
                          "Error",
                          "Please upload your photo",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        progressController.updateProgress(1.0); // full progress
                        // Navigate to next screen
                        // Get.to(() => NextScreen());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryText,
                      foregroundColor: AppColors.textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Next"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
