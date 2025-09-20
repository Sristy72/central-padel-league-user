import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/join_league_controller/join_league_controller.dart';

class UploadBox extends StatelessWidget {
  final controller = Get.find<JoinLeagueController>();
  UploadBox({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    return Obx(() {
      final hasImage = ctrl.selectedLogo.value != null;
      return InkWell(
        onTap: ctrl.pickLogo,
        child: Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.textFieldBackground,
            border: Border.all(color: AppColors.textFieldBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: hasImage
                ? Image.file(
                    File(ctrl.selectedLogo.value!.path),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.image_outlined, color: AppColors.gray),
                      const SizedBox(height: 8),
                      'Drop your files here'.text14w400(color: AppColors.gray),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: 'Choose File'.text12w600(color: AppColors.white),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
