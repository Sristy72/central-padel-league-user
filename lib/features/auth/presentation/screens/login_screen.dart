import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/constants/app_images.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import 'package:karlfive/features/auth/presentation/controller/remember_me_controller.dart';

import '../../../../core/common/widgets/app_logo.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/common/widgets/form_error_message.dart';
import '../../../../core/common/widgets/or_divider_with_circle.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/debug_print.dart' hide DPrint;
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  /// [Controller]
  final _authController = Get.find<AuthController>();
  final rememberMeController = Get.put(RememberMeController());

  @override
  void dispose() {
    _obscurePassword.dispose();

    _passwordController.dispose();

    _passwordFocus.dispose();

    // _authController.dispose();
    super.dispose();
  }

  /// [Submit the form]
  /// Check the email and password validations
  ///
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Hide keyboard immediately
    if (mounted) FocusScope.of(context).unfocus();

    try {
      DPrint.log(
        "Login Form Data ${_emailController.text}, ${_passwordController.text}",
      );

      await _authController.login(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      DPrint.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AppScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppLogo(
                          images: appImages.app_logo_landscape,
                          height: 193,
                          width: 193,
                        ),

                        SizedBox(height: 37),

                        Text(
                          'Log In Your Account',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),

                        SizedBox(height: 16),

                        /// [Api Error messages]
                        AnimatedBuilder(
                          animation: _authController,
                          builder: (context, _) {
                            return FormErrorMessage(
                              message: _authController.errorMessage.value,
                            );
                          },
                        ),

                        /// [Text Field] Email
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Enter your email",
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.prefixIconColor,
                            ),
                          ),
                          validator: Validators.email,
                          onFieldSubmitted: (_) => FocusScope.of(
                            context,
                          ).requestFocus(_passwordFocus),
                          autofillHints: const [AutofillHints.email],
                        ),

                        Gap.h16,

                        /// [Text field] Password
                        ValueListenableBuilder<bool>(
                          valueListenable: _obscurePassword,
                          builder: (context, obscure, _) {
                            return TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: obscure,
                              textInputAction: TextInputAction.done,
                              style: TextStyle(color: AppColors.primaryText),
                              decoration: context.primaryInputDecoration
                                  .copyWith(
                                    hintText: "Enter your Password",
                                    prefixIcon: Icon(
                                      Icons.lock_open_outlined,
                                      color: AppColors.prefixIconColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: SizedBox(
                                        width: 15,
                                        height: 7,
                                        child: Image.asset(
                                          appImages.suffix_eye_icon,
                                        ),
                                      ),
                                      onPressed: () =>
                                          _obscurePassword.value = !obscure,
                                    ),
                                  ),

                              // validator: Validators.password,
                              onFieldSubmitted: (_) => _submit(),
                            );
                          },
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(
                                  () => Checkbox(
                                    value:
                                        rememberMeController.rememberMe.value,
                                    activeColor: AppColors.checkboxColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    checkColor: AppColors.prefixIconColor,
                                    // color of the check mark
                                    side: BorderSide(
                                      color: AppColors.prefixIconColor,
                                      // border color when unchecked
                                      width: 1,
                                    ),
                                    onChanged: (_) =>
                                        rememberMeController.toggleRememberMe(),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: rememberMeController.toggleRememberMe,
                                  // tap text also toggles
                                  child: const Text(
                                    "Remember Me",
                                    style: TextStyle(
                                      color: AppColors.rememberMeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: 'Forgot Password ?'.text14w400(
                              color: AppColors.buttonText,
                            ),
                          ),
                        ),

                        /// [Button] Sign In
                        // ListenableBuilder(
                        //   listenable: _authController,
                        //   builder: (context, _) {
                        //     return PrimaryButton(
                        //       isLoading: _authController.isLoading.value,
                        //       onPressed: _submit,
                        //       text: "Sign In",
                        //     );
                        //   },
                        // ),
                        Obx(
                          () => PrimaryButton(
                            isLoading: _authController.isLoading.value,
                            onPressed: _submit,
                            text: "Sign In",
                          ),
                        ),
                        OrDividerWithCircle(),

                        Gap.h12,

                        // ListenableBuilder(
                        //   listenable: _authController,
                        //   builder: (context, _) {
                        //     return SecondaryButton(
                        //       isLoading: _authController.isLoading.value,
                        //       onPressed: _submit,
                        //       text: "Sign In",
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Don't have an account? ".text14w400(),

                      'Sign Up'.text14w400(color: AppColors.buttonText),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
