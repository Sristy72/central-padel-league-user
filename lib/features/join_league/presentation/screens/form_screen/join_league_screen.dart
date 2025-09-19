import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_bottom_navbar.dart';
import '../../../../../core/common/widgets/app_scaffold.dart';
import '../../../../../core/common/widgets/form_error_message.dart';
import '../../../../../core/theme/app_buttoms.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../controller/join_league_controller/join_league_controller.dart';
import '../../widgets/check_box.dart';
import '../../widgets/lebel_field.dart';
import '../../widgets/player_dropdown_box.dart';
import '../../widgets/upload_box.dart';
import '../../widgets/league_dropdown.dart';

class JoinLeagueScreen extends StatefulWidget {
  const JoinLeagueScreen({super.key});

  @override
  State<JoinLeagueScreen> createState() => _JoinLeagueScreenState();
}

class _JoinLeagueScreenState extends State<JoinLeagueScreen> {
  final controller = Get.find<JoinLeagueController>();

  /// Submit form with validation
  void _submit() {
    if (!controller.formKey.currentState!.validate()) return;

    // Hide keyboard
    FocusScope.of(context).unfocus();

    controller.submitApplication();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Join League',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Build your team and join the league—add players, set details, and get ready to compete!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  /// Error message from controller
                  //

                  const SizedBox(height: 8),

                  /// Form fields
                  LabeledField(
                    hint: 'Team Name',
                    controller: controller.teamNameController,
                    validator: Validators.required,
                  ),
                  LabeledField(
                    hint: 'Captain Name',
                    controller: controller.captainNameController,
                    validator: Validators.required,
                  ),
                  LabeledField(
                    hint: 'Partner Name',
                    controller: controller.partnerNameController,
                  ),
                  PlayerLevelDropdown(),
                  const SizedBox(height: 12             ),
                  LabeledField(
                    hint: 'Email',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  LabeledField(
                    hint: 'Contact Number',
                    controller: controller.contactNumberController,
                    keyboardType: TextInputType.phone,
                    validator: Validators.required,
                  ),

                  const SizedBox(height: 8),
                  'Upload your logo/photo'.text14w500(color: AppColors.white),
                  const SizedBox(height: 8),
                  UploadBox(),

                  const SizedBox(height: 8),
                  LeagueDropdown(),

                  const SizedBox(height: 8),
                  CheckRow(
                    valueListenable: controller.agreedRules,
                    label: 'I agree to the League Rules & Code of Conduct',
                    onChanged: (v) => controller.agreedRules.value = v ?? false,
                  ),
                  const SizedBox(height: 12),
                  CheckRow(
                    valueListenable: controller.confirmedAvailability,
                    label:
                        'I confirm my availability for all scheduled matches.',
                    onChanged: (v) =>
                        controller.confirmedAvailability.value = v ?? false,
                  ),

                  const SizedBox(height: 24),

                  /// Submit button
                  Obx(
                    () => PrimaryButton(
                      isLoading: controller.isLoading.value,
                      onPressed: _submit,
                      text: 'Apply to League',
                      backgroundColor: AppColors.textFieldBackground,
                      textColor: AppColors.primaryGreen,
                      width: 150,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
    );
  }
}
