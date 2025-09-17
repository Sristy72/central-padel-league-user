import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


class PinCode extends StatelessWidget {
  const PinCode({super.key});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 4,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      autoFocus: false,

      obscureText: true,
      textStyle: const TextStyle(
        color: Colors.black, // dot (text) color
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),

      cursorColor: Colors.black,
      enableActiveFill: true, ///important for background fill

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(6),
        fieldHeight: 56,
        fieldWidth: 50,

        ///remove borders
        inactiveColor: Colors.transparent,
        activeColor: Colors.transparent,
        selectedColor: Colors.transparent,

        /// grey background
        inactiveFillColor: Color(0xFF2E2E2E),
        activeFillColor: Color(0xFF2E2E2E),
        selectedFillColor: Color(0xFF2E2E2E),
      ),
    );
  }
}
