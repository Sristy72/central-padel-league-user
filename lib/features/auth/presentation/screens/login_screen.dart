import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/theme/app_buttoms.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';

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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppLogo(),

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
                              decoration: context.primaryInputDecoration
                                  .copyWith(hintText: "Enter your email"),
                              validator: Validators.email,
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(_passwordFocus),
                              autofillHints: const [AutofillHints.email],
                            ),
                            Gap.h12,

                            /// [Text field] Password
                            ValueListenableBuilder<bool>(
                              valueListenable: _obscurePassword,
                              builder: (context, obscure, _) {
                                return TextFormField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  obscureText: obscure,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    color: AppColors.primaryText,
                                  ),
                                  decoration: context.primaryInputDecoration
                                      .copyWith(
                                        hintText: "Enter your Password",

                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            obscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: AppColors.buttonText,
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
