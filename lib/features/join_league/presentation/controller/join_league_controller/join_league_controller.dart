import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../core/base/base_controller.dart';
import '../../../../../core/network/services/multiple_form_data_manager.dart';
import '../../../../payment/presentation/screens/payment_font_screen.dart';
import '../../../data/model/league_reponse_model.dart';
import '../../../domain/repo/team_repo.dart';

class JoinLeagueController extends BaseController {
  final JoinLeagueRepository _repository;

  JoinLeagueController(this._repository);

  final _multiFormDataManager = MultiFormDataManager();

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
    {'id': 4, 'label': 'Advanced 4.5+', 'asset': null},
    {'id': 5, 'label': 'Pro', 'asset': null},
  ];

  final leagues = RxList<LeagueResponeModel>();

  @override
  void onInit() {
    super.onInit();
    fetchLeagues();
  }

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
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null) selectedLogo.value = file;
      clearError();
    } catch (e) {
      setError("Failed to pick image");
    }
  }

  Future<void> fetchLeagues() async {
    setLoading(true);
    final response = await _repository.getAllLeague();
    response.fold(
      (fail) {
        setError(fail.message);
        setLoading(false);
      },
      (success) {
        leagues.assignAll(success.data);
        DPrint.log("Leagues fetched: ${leagues.length}");
        setLoading(false);
      },
    );
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
      _multiFormDataManager.clear();

      // Add all form data from user input
      _multiFormDataManager.addTextData('teamName', teamNameController.text);
      _multiFormDataManager.addTextData(
        'captainName',
        captainNameController.text,
      );
      _multiFormDataManager.addTextData(
        'partnerName',
        partnerNameController.text,
      );
      _multiFormDataManager.addTextData('email', emailController.text);
      _multiFormDataManager.addTextData(
        'contactNumber',
        contactNumberController.text,
      );
      _multiFormDataManager.addTextData('league', selectedLeague.value);

      final playerLevelString = _getPlayerLevelString(
        selectedPlayerLevelId.value!,
      );
      _multiFormDataManager.addTextData('playerLevels', playerLevelString);

      _multiFormDataManager.addTextData(
        'agreedToRules',
        agreedRules.value.toString(),
      );
      _multiFormDataManager.addTextData(
        'confirmedAvailability',
        confirmedAvailability.value.toString(),
      );

      if (selectedLogo.value != null) {
        final file = File(selectedLogo.value!.path);
        _multiFormDataManager.addFile(file, type: 'image');
      }

      final formData = await _multiFormDataManager.toFormDataWithValidation();
      final response = await _repository.createTeam(formData);

      response.fold(
        (fail) {
          setError(fail.message);
          DPrint.log("API Error: ${fail.message}");
        },
        (success) {
          DPrint.log("Application submitted: ${success.message}");
          final selectedLeagueModel = leagues.firstWhere(
            (league) => league.id == selectedLeague.value,
          );
          final amount = double.tryParse(selectedLeagueModel.price ?? '0.0') ?? 0.0;
          Get.to(
            () => PaymentDialog(
              userID: success.data.user,
              leagueID: success.data.league,
              teamID: success.data.id,
              amount: amount.toString(),
            ),
            transition: Transition.rightToLeft,
          );
        },
      );
    } catch (e) {
      setError("Submission error: $e");
      DPrint.log("Error details: $e");
    } finally {
      setLoading(false);
    }
  }

  // Helper method to convert player level ID to string representation
  String _getPlayerLevelString(int levelId) {
    switch (levelId) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Intermediate high';
      case 4:
        return 'Advanced 4.5+';
      case 5:
        return 'Pro';
      default:
        return 'Intermediate';
    }
  }

  void updateSelectedLeague(String leagueId) {
    selectedLeague.value = leagueId;
    DPrint.log("League ID set: $leagueId");
  }

  // Method to update player level
  void updatePlayerLevel(int levelId) {
    selectedPlayerLevelId.value = levelId;
  }

  // Method to toggle agreement rules
  void toggleAgreedRules() {
    agreedRules.value = !agreedRules.value;
  }

  // Method to toggle availability confirmation
  void toggleConfirmedAvailability() {
    confirmedAvailability.value = !confirmedAvailability.value;
  }

  // Validation methods
  String? validateTeamName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a team name';
    }
    if (value.length < 2) {
      return 'Team name must be at least 2 characters';
    }
    return null;
  }

  String? validateCaptainName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter captain name';
    }
    if (value.length < 2) {
      return 'Captain name must be at least 2 characters';
    }
    return null;
  }

  String? validatePartnerName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter partner name';
    }
    if (value.length < 2) {
      return 'Partner name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    if (!value.isEmail) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter contact number';
    }
    if (value.length < 10) {
      return 'Please enter a valid contact number';
    }
    return null;
  }
}
