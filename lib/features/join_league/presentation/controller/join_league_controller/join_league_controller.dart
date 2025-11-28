import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/base/base_controller.dart';
import '../../../../../core/network/services/multiple_form_data_manager.dart';
import '../../../../../core/theme/app_colors.dart';
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
  final selectedLeagueType = 'public'.obs; // Track selected league type
  final otpController = TextEditingController(); // Controller for OTP input
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
    otpController.dispose(); // Dispose OTP controller
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
    try {
      // Fetch only public leagues for the dropdown
      final response = await _repository.getAllLeague(leagueType: 'public', limit: 200);
      response.fold(
        (fail) {
          setError(fail.message);
          setLoading(false);
        },
        (success) {
          leagues.assignAll(success.data);
          DPrint.log("✅ Public leagues fetched: ${leagues.length}");
          setLoading(false);
        },
      );
    } catch (e) {
      DPrint.log("❌ Error fetching leagues: $e");
      setError("Failed to load leagues");
      setLoading(false);
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

      // Create FormData manually to use custom field name for logo
      final formData = dio.FormData();
      
      // Add text fields
      _multiFormDataManager.textData.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });
      
      // Add logo file with correct field name 'logo' as per API requirements
      if (selectedLogo.value != null) {
        final file = File(selectedLogo.value!.path);
        formData.files.add(MapEntry(
          'logo', // API expects 'logo' as field name
          await dio.MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }
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
    
    // Find the selected league and update the type
    final selectedLeagueModel = leagues.firstWhere(
      (league) => league.id == leagueId,
      orElse: () => leagues.first,
    );
    
    selectedLeagueType.value = selectedLeagueModel.leagueType;
    DPrint.log("Selected league type: ${selectedLeagueModel.leagueType}");
  }

  // Method to update player level
  void updatePlayerLevel(int levelId) {
    selectedPlayerLevelId.value = levelId;
  }

  // Method to update selected league and track its type - DUPLICATE REMOVED

  // Method to show private league OTP dialog
  Future<void> showPrivateLeagueOtpDialog() async {
    otpController.clear(); // Clear previous OTP
    
    await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.textFieldBackground,
        title: const Text(
          'Join Private League',
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the OTP (League Code) provided by the league owner to join a private league.',
              style: TextStyle(color: AppColors.white, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                hintText: 'Enter League OTP/Code',
                hintStyle: const TextStyle(color: AppColors.textFieldTextiHint),
                filled: true,
                fillColor: AppColors.textFieldBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.textFieldTextiHint),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.textFieldTextiHint),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryGreen),
                ),
              ),
              style: const TextStyle(color: AppColors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textFieldTextiHint)),
          ),
          ElevatedButton(
            onPressed: () => _findAndJoinPrivateLeagueByOtp(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Find & Join League', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  // Method to find and join private league by OTP
  Future<void> _findAndJoinPrivateLeagueByOtp() async {
    if (otpController.text.trim().isEmpty) {
      setError("Please enter OTP/League Code");
      return;
    }

    try {
      setLoading(true);
      
      // Fetch all leagues to find the one with matching leagueCode
      final response = await _repository.getAllLeague(limit: 200);
      
      response.fold(
        (fail) {
          setError("Failed to verify OTP: ${fail.message}");
          setLoading(false);
        },
        (success) {
          // Find league with matching leagueCode (OTP)
          final privateLeague = success.data.firstWhere(
            (league) => league.leagueCode == otpController.text.trim() && 
                        league.leagueType.toLowerCase() == 'private',
            orElse: () => success.data.first, // This will cause an error if not found
          );

          // Check if we found a matching private league
          final foundMatch = success.data.any(
            (league) => league.leagueCode == otpController.text.trim() && 
                        league.leagueType.toLowerCase() == 'private'
          );

          if (foundMatch) {
            // Success! Set this as selected league and close dialog
            selectedLeague.value = privateLeague.id;
            selectedLeagueType.value = 'private';
            Get.back(result: true);
            clearError();
            setLoading(false);
            
            // Show success message
            Get.snackbar(
              'Success',
              'Private league "${privateLeague.leagueName}" found! You can now complete your application.',
              backgroundColor: AppColors.primaryGreen.withOpacity(0.8),
              colorText: AppColors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            
            DPrint.log("✅ Private league found and selected: ${privateLeague.leagueName}");
          } else {
            setError("Invalid OTP/League Code. Please check with the league owner.");
            setLoading(false);
          }
        },
      );
    } catch (e) {
      setError("Error verifying OTP: $e");
      setLoading(false);
      DPrint.log("❌ Error in OTP verification: $e");
    }
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
