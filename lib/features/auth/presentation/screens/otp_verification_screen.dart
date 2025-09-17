import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/common/widgets/app_logo.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/features/auth/presentation/widgets/otp_code_field.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late TapGestureRecognizer _resendOtp;

  @override
  void initState() {
    // TODO: implement initState
    _resendOtp = TapGestureRecognizer()
      ..onTap = (){
        _submit(){

        }
      };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 51,),
              AppLogo(images: appImages.app_logo_landscape),
              SizedBox(height: 74,),

              Text('Enter OTP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.white),),
              SizedBox(height: 12,),
              Text('Enter your receive OTP', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400, color: AppColors.rememberMeColor
              ),),
              SizedBox(height: 32,),

              PinCode(),

              SizedBox(height: 24,),

              Center(
                child: RichText(text: TextSpan(
                    text: 'Didn\'t Receive OTP? ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColors.rememberMeColor,
                    ),
                    children: [
                      TextSpan(
                          text: 'RESEND OTP',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryGreen
                          ),
                          recognizer: _resendOtp
                      ),
                    ]
                )),
              ),

              SizedBox(height: 12,),
              PrimaryButton(onPressed: (){}, text: 'Verify Now')
            ],
          ),
        ),
      ),
    );
  }
}
