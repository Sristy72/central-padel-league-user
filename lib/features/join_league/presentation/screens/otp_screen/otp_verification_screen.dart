import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/core/theme/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../controller/otp_controller/otp_controller.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/app_logo_landscape.png",
                    height: 192,
                    width: 193,
                  ),
                ),
                const SizedBox(height: 74),

                Text(
                  "Enter OTP",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "Enter the OTP you received",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff9CA3AF),
                  ),
                ),
                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.otpCode.value = value;
                    },
                    onCompleted: (value) {
                      controller.otpCode.value = value;
                      controller.verifyOtp(); // ✅ call API when completed
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(6),
                      fieldHeight: 50,
                      fieldWidth: 47,
                      activeColor: AppColors.primaryGreen,
                      selectedColor: AppColors.buttonText,
                      inactiveColor: Colors.grey,
                      activeFillColor: const Color(0xff2D2D2D),
                      selectedFillColor: const Color(0xff2D2D2D),
                      inactiveFillColor: const Color(0xff2D2D2D),
                    ),
                    cursorColor: AppColors.primaryGreen,
                    enableActiveFill: true,
                  ),
                ),

                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.gray,
                    ),
                    children: [
                      TextSpan(
                        text: "Resend",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // controller.resendOtp();
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        onPressed: controller.verifyOtp,
                        text: "Verify OTP",
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
