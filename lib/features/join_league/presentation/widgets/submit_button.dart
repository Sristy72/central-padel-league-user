import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_buttoms.dart';
import '../controller/join_league_controller.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JoinLeagueController>();

    return Obx(
      () => PrimaryButton(
        isLoading: controller.isLoading.value,
        onPressed: controller.submitApplication,
        text: "Apply to League",
        width: double.infinity,
      ),
    );
  }
}
