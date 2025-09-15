import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../controller/join_league_controller.dart';

class AgreementCheckboxes extends StatelessWidget {
  const AgreementCheckboxes({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JoinLeagueController>();

    return Column(
      children: [
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: controller.agreeToRules.value,
                  onChanged: (value) => controller.agreeToRules.value = value!,
                  fillColor: MaterialStateProperty.all(Colors.blue),
                  checkColor: Colors.white,
                ),
              ),
              Gap.w8,
              Expanded(
                child: "I agree to the League Rules & Code of Conduct"
                    .text12w300(color: AppColors.white),
              ),
            ],
          ),
        ),
        Gap.h8,
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: controller.confirmAvailability.value,
                  onChanged: (value) =>
                      controller.confirmAvailability.value = value!,
                  fillColor: MaterialStateProperty.all(Colors.blue),
                  checkColor: Colors.white,
                ),
              ),
              Gap.w8,
              Expanded(
                child: "I confirm my availability for all scheduled matches."
                    .text12w300(color: AppColors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
