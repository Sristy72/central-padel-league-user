import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;
  final double width;

  const AppLogo({super.key, this.height = 120, this.width = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo_landscape.png',
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }
}
