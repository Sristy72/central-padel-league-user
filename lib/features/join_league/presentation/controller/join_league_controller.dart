import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/join_league_model.dart';
import '../../data/repositories/join_league_repository.dart';

class JoinLeagueController extends GetxController {
  final JoinLeagueRepository _repository = Get.find();

  // Form field controllers
  final teamNameController = TextEditingController();
  final captainNameController = TextEditingController();
  final partnerNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactNumberController = TextEditingController();
  final leagueController = TextEditingController();

  // Focus nodes
  final teamNameFocusNode = FocusNode();
  final captainNameFocusNode = FocusNode();
  final partnerNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final contactNumberFocusNode = FocusNode();
  final leagueFocusNode = FocusNode();

  // Reactive variables
  final selectedPlayerLevel = PlayerLevel.beginner.obs;
  final agreeToRules = false.obs;
  final confirmAvailability = false.obs;
  final isLoading = false.obs;
  final selectedLogo = Rxn<String>();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Player levels dropdown options
  final List<PlayerLevel> playerLevels = PlayerLevel.values;

  @override
  void onClose() {
    teamNameController.dispose();
    captainNameController.dispose();
    partnerNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    leagueController.dispose();

    teamNameFocusNode.dispose();
    captainNameFocusNode.dispose();
    partnerNameFocusNode.dispose();
    emailFocusNode.dispose();
    contactNumberFocusNode.dispose();
    leagueFocusNode.dispose();
    super.onClose();
  }

  // Validation methods
  String? validateTeamName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter team name';
    }
    return null;
  }

  String? validateCaptainName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter captain name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter contact number';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateLeague(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a league';
    }
    return null;
  }

  // Handle player level selection
  void setPlayerLevel(PlayerLevel? level) {
    if (level != null) {
      selectedPlayerLevel.value = level;
    }
  }

  // Handle logo upload
  void uploadLogo() {
    // TODO: Implement logo upload functionality
    // This would typically open image picker and set selectedLogo.value
    selectedLogo.value = 'https://example.com/logo.png'; // Mock URL
  }

  // Form submission
  Future<void> submitApplication() async {
    if (formKey.currentState!.validate()) {
      if (!agreeToRules.value || !confirmAvailability.value) {
        Get.snackbar('Error', 'Please agree to all terms and conditions');
        return;
      }

      isLoading.value = true;

      try {
        // Prepare data for API
        final request = JoinLeagueRequest(
          teamName: teamNameController.text,
          captainName: captainNameController.text,
          partnerName: partnerNameController.text,
          playerLevel: selectedPlayerLevel.value,
          email: emailController.text,
          contactNumber: contactNumberController.text,
          logoUrl: selectedLogo.value,
          league: leagueController.text,
          agreeToRules: agreeToRules.value,
          confirmAvailability: confirmAvailability.value,
        );

        final response = await _repository.submitApplication(request);

        if (response.success) {
          Get.snackbar('Success', response.message);
          // Clear form or navigate to success screen
          // Get.offAllNamed('/home');
        } else {
          Get.snackbar('Error', response.message);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to submit application: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
