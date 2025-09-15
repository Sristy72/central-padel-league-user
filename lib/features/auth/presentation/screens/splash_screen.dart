import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:karlfive/core/common/widgets/app_logo.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/auth/presentation/controller/splash_screen_controller.dart';
import 'package:karlfive/features/auth/presentation/screens/login_screen.dart';

import '../../../../core/common/constants/app_images.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({super.key});

  final controller = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {

    return AppScaffold(body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: AppLogo(images: appImages.app_logo_portrait, height: 144, width: 144,)),
      ],
    ));
  }
}
