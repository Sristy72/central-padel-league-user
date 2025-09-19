import 'package:flutter/material.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class LabeledField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const LabeledField({
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.primaryText, fontSize: 14,fontWeight: FontWeight.w400),
        decoration: context.primaryInputDecoration.copyWith(hintText: hint),
        validator: validator,
      ),
    );
  }
}
