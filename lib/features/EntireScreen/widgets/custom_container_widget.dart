import 'package:flutter/material.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class CustomContainerWidget extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  const CustomContainerWidget({
    super.key,
    required this.child,
    this.height = 474,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(padding: const EdgeInsets.all(16.0), child: child),
      ),
    );
    // return Card(
    //   color: AppColors.cardColor,
    //   // dark background like figma
    //   // elevation: 4,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    //   child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    // );
  }
}
