import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../controller/join_league_controller.dart';

class UploadLogoWidget extends StatelessWidget {
  const UploadLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JoinLeagueController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Upload your logo/photo".text14w500(color: AppColors.white),
        Gap.h8,
        GestureDetector(
          onTap: controller.uploadLogo,
          child: Obx(
            () => Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: controller.selectedLogo.value != null
                      ? Colors.green
                      : Colors.grey.shade600,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: controller.selectedLogo.value != null
                  ? Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 32,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: Colors.grey.shade400,
                          size: 32,
                        ),
                        Gap.h8,
                        "Tap to upload logo".text12w400(
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
