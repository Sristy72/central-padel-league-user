import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import '../controller/join_league_controller.dart';

class CaptainNameField extends StatelessWidget {
  const CaptainNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JoinLeagueController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Captain Name".text14w500(color: AppColors.white),
        Gap.h8,
        TextFormField(
          controller: controller.captainNameController,
          focusNode: controller.captainNameFocusNode,
          style: TextStyle(color: AppColors.white, fontSize: 14),
          decoration: context.primaryInputDecoration.copyWith(
            hintText: "Enter captain name",
            filled: true,
            fillColor: AppColors.gray,
          ),
          validator: controller.validateCaptainName,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(
            context,
          ).requestFocus(controller.partnerNameFocusNode),
        ),
      ],
    );
  }
}
