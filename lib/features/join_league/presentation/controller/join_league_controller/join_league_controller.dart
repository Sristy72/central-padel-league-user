import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/base/base_controller.dart';
import '../../../data/model/join_league_model/join_league_model_request.dart';
import '../../../data/repositories/join_league/join_league.dart';

class JoinLeagueController extends BaseController {
  final JoinLeagueRepository _repository = JoinLeagueRepository();

  final formKey = GlobalKey<FormState>();

  final teamNameController = TextEditingController();
  final captainNameController = TextEditingController();
  final partnerNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactNumberController = TextEditingController();

  final selectedLeague = ''.obs;
  final selectedPlayerLevelId = RxnInt();
  final agreedRules = false.obs;
  final confirmedAvailability = false.obs;
  final selectedLogo = Rxn<XFile>();

  final List<Map<String, Object?>> playerLevels = const [
    {'id': 1, 'label': 'Beginner', 'asset': null},
    {'id': 2, 'label': 'Intermediate', 'asset': null},
    {'id': 3, 'label': 'Intermediate high', 'asset': null},
    {'id': 4, 'label': 'Advance', 'asset': null},
    {'id': 5, 'label': 'Pro', 'asset': null},
  ];

  @override
  void onClose() {
    teamNameController.dispose();
    captainNameController.dispose();
    partnerNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    super.onClose();
  }

  Future<void> pickLogo() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (file != null) selectedLogo.value = file;
      clearError();
    } catch (e) {
      setError("Failed to pick image");
    }
  }

  Future<void> submitApplication() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (selectedLeague.value.isEmpty) {
      setError("Please select a league");
      return;
    }
    if (selectedPlayerLevelId.value == null) {
      setError("Please select a player level");
      return;
    }
    if (!agreedRules.value || !confirmedAvailability.value) {
      setError("Please agree and confirm to proceed");
      return;
    }

    clearError();
    setLoading(true);
    try {
      final request = JoinLeagueRequest(
        teamName: teamNameController.text,
        captainName: captainNameController.text,
        partnerName: partnerNameController.text,
        email: emailController.text,
        contactNumber: contactNumberController.text,
        league: selectedLeague.value,
        playerLevel: selectedPlayerLevelId.value!,
        logoPath: selectedLogo.value?.path,
      );

      final response = await _repository.submitApplication(request);

      if (response.success) {
        Get.snackbar("Application Submitted", response.message);
      } else {
        setError(response.message);
      }
    } catch (e) {
      setError("Submission error");
    } finally {
      setLoading(false);
    }
  }
}
