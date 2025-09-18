 import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';

class CheckRow extends StatelessWidget {
  final RxBool valueListenable;
  final String label;
  final ValueChanged<bool?> onChanged;

  const CheckRow({
    required this.valueListenable,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.center  ,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: valueListenable.value,
            onChanged: onChanged,
            activeColor: Colors.transparent,
            checkColor: AppColors.primaryGreen,
            side: const BorderSide(color: AppColors.textFieldBorder),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 6),
          Expanded(child: label.text14w400(color: AppColors.white)),
        ],
      ),
    );
  }
}
