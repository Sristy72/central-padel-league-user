import 'package:flutter/material.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class CustomCardWidget extends StatelessWidget {
  final Widget child;
  const CustomCardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor, // dark background like figma
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}
