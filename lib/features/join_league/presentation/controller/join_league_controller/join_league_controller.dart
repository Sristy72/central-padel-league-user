import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/base/base_controller.dart';
import '../../../../../core/network/services/multiple_form_data_manager.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../home/presentation/screens/home_screen.dart';
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
  final playerEmailController = TextEditingController(); // Co-player email
  final contactNumberController = TextEditingController();

  final selectedLeague = ''.obs;
  final selectedLeagueType = 'public'.obs; // Track selected league type
  final otpController = TextEditingController(); // Controller for OTP input
  final selectedPlayerLevelId = RxnInt();
  final agreedRules = false.obs;
  final confirmedAvailability = false.obs;
  final selectedLogo = Rxn<XFile>();
  final isVerifyingOtp = false.obs; // Track OTP verification loading state

  final List<Map<String, Object?>> playerLevels = const [
    {'id': 1, 'label': 'Beginner', 'asset': null},
    {'id': 2, 'label': 'Intermediate', 'asset': null},
    {'id': 3, 'label': 'Intermediate high', 'asset': null},
    {'id': 4, 'label': 'Advanced 4.5+', 'asset': null},
    {'id': 5, 'label': 'Pro', 'asset': null},
  ];

  final leagues = RxList<LeagueResponeModel>(); // Public leagues only
  final selectedPrivateLeague = Rxn<LeagueResponeModel>(); // Selected private league
  final selectedPublicLeague = Rxn<LeagueResponeModel>(); // Selected public league via OTP

  // Computed property for dropdown display - public leagues + selected private league + selected public league
  List<LeagueResponeModel> get displayLeagues {
    try {
      // Return empty list immediately if leagues is not initialized
      if (leagues.isEmpty) {
        return <LeagueResponeModel>[];
      }
      
      // Safely filter public leagues with null checks
      final publicLeagues = <LeagueResponeModel>[];
      for (final league in leagues) {
        try {
          if (league.leagueType.toLowerCase() == 'public') {
            publicLeagues.add(league);
          }
        } catch (e) {
          DPrint.log('Error filtering league ${league.id}: $e');
          continue; // Skip problematic leagues
        }
      }
      
      // Add selected private league to display if it exists and is valid
      final privateLeague = selectedPrivateLeague.value;
      if (privateLeague != null && 
          privateLeague.id.isNotEmpty && 
          privateLeague.leagueName.isNotEmpty) {
        try {
          // Check if it's not already in the list
          final isAlreadyInList = publicLeagues.any((league) => league.id == privateLeague.id);
          if (!isAlreadyInList) {
            publicLeagues.add(privateLeague);
          }
        } catch (e) {
          DPrint.log('Error adding private league: $e');
        }
      }

      // Add selected public league via OTP to display if it exists and is valid
      final otpPublicLeague = selectedPublicLeague.value;
      if (otpPublicLeague != null && 
          otpPublicLeague.id.isNotEmpty && 
          otpPublicLeague.leagueName.isNotEmpty) {
        try {
          // Check if it's not already in the list
          final isAlreadyInList = publicLeagues.any((league) => league.id == otpPublicLeague.id);
          if (!isAlreadyInList) {
            publicLeagues.add(otpPublicLeague);
          }
        } catch (e) {
          DPrint.log('Error adding public league via OTP: $e');
        }
      }
      
      return List<LeagueResponeModel>.from(publicLeagues);
    } catch (e) {
      DPrint.log('Critical error in displayLeagues getter: $e');
      return <LeagueResponeModel>[];
    }
  }

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
    playerEmailController.dispose(); // Dispose co-player email controller
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
      // Fetch only public leagues for the dropdown, excluding user's own leagues
      final response = await _repository.getAllLeague(leagueType: 'public', limit: 200);
      response.fold(
        (fail) {
          setError(fail.message);
          setLoading(false);
        },
        (success) {
          // Filter out leagues created by the current user
          final filteredLeagues = success.data.where((league) {
            // You can implement user ID check here if available
            // For now, we'll show all public leagues
            // TODO: Add user ID filtering when user data is available
            return true; // league.user.id != currentUserId;
          }).toList();
          
          leagues.assignAll(filteredLeagues);
          DPrint.log("✅ Public leagues fetched (excluding own): ${leagues.length}");
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
    
    // Check if a league is selected (either from dropdown or private league via OTP)
    if (selectedLeague.value.isEmpty) {
      setError("Please select a league");
      return;
    }
    
    if (selectedPlayerLevelId.value == null) {
      setError("Please select a player level");
      return;
    }
    
    if (!agreedRules.value || !confirmedAvailability.value) {
      setError("Please agree to rules and confirm availability to proceed");
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
      _multiFormDataManager.addTextData('playerEmail', playerEmailController.text); // Co-player email
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
          
          // Find the selected league from display leagues (public + selected private)
          final selectedLeagueModel = displayLeagues.firstWhere(
            (league) => league.id == selectedLeague.value,
            orElse: () => displayLeagues.isNotEmpty ? displayLeagues.first : leagues.first,
          );
          
          // Check if the selected league is private
          if (selectedLeagueModel.leagueType.toLowerCase() == 'private') {
            // For private leagues, show success message and navigate back
            DPrint.log("✅ Private league application successful - No payment required");
            
            Get.snackbar(
              'Success',
              'Your application to join "${selectedLeagueModel.leagueName}" has been submitted successfully!',
              backgroundColor: AppColors.primaryGreen.withOpacity(0.8),
              colorText: AppColors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.all(16),
            );
            
            // Clear form and navigate back after delay
            Future.delayed(const Duration(seconds: 1), () {
              // Clear form fields
              teamNameController.clear();
              captainNameController.clear();
              partnerNameController.clear();
              emailController.clear();
              playerEmailController.clear(); // Clear co-player email
              contactNumberController.clear();
              selectedLogo.value = null;
              selectedLeague.value = '';
              selectedPrivateLeague.value = null;
              selectedPlayerLevelId.value = null;
              agreedRules.value = false;
              confirmedAvailability.value = false;
              
              // Navigate to home screen and clear navigation stack
              Get.offAll(() => const HomeScreen());
            });
          } else {
            // For public leagues, proceed to payment
            DPrint.log("🔵 Public league - Proceeding to payment");
            
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
          }
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
    try {
      // Validate input
      if (leagueId.isEmpty) {
        DPrint.log('Cannot select league: empty league ID');
        return;
      }
      
      selectedLeague.value = leagueId;
      DPrint.log("League ID set: $leagueId");
      
      // Safely find the selected league from display leagues
      try {
        final availableLeagues = displayLeagues;
        if (availableLeagues.isEmpty) {
          DPrint.log('No leagues available for type detection');
          selectedLeagueType.value = 'public'; // Default fallback
          return;
        }
        
        LeagueResponeModel? selectedLeagueModel;
        for (final league in availableLeagues) {
          try {
            if (league.id == leagueId) {
              selectedLeagueModel = league;
              break;
            }
          } catch (e) {
            DPrint.log('Error checking league ${league.id}: $e');
            continue;
          }
        }
        
        if (selectedLeagueModel != null) {
          selectedLeagueType.value = selectedLeagueModel.leagueType;
          DPrint.log("Selected league type: ${selectedLeagueModel.leagueType}");
        } else {
          DPrint.log('League not found in available leagues, using first available');
          if (availableLeagues.isNotEmpty) {
            selectedLeagueType.value = availableLeagues.first.leagueType;
          } else {
            selectedLeagueType.value = 'public';
          }
        }
        
      } catch (e) {
        DPrint.log('Error in league type detection: $e');
        selectedLeagueType.value = 'public'; // Safe fallback
      }
      
    } catch (e) {
      DPrint.log('Critical error updating selected league: $e');
      // Ensure we don't leave the state in an invalid condition
      try {
        selectedLeague.value = leagueId;
        selectedLeagueType.value = 'public';
      } catch (e2) {
        DPrint.log('Failed to set fallback values: $e2');
      }
    }
  }

  // Method to update player level
  void updatePlayerLevel(int levelId) {
    selectedPlayerLevelId.value = levelId;
  }

  // Method to update selected league and track its type - DUPLICATE REMOVED

  // Method to show unified OTP dialog that works for both public and private leagues
  Future<void> showUnifiedLeagueOtpDialog() async {
    otpController.clear(); // Clear previous OTP
    isVerifyingOtp.value = false; // Reset loading state
    
    await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.textFieldBackground,
        title: const Text(
          'Join League by OTP',
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter the OTP (League Code) provided by the league organizer or owner. The system will automatically detect whether it is a public or private league.',
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
          Obx(
            () => ElevatedButton(
              onPressed: isVerifyingOtp.value ? null : () => _findAndJoinLeagueByOtpUnified(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.5),
              ),
              child: isVerifyingOtp.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Find League', style: TextStyle(color: AppColors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // Method to find and join league by OTP (auto-detects public or private)
  Future<void> _findAndJoinLeagueByOtpUnified() async {
    if (otpController.text.trim().isEmpty) {
      setError("Please enter OTP/League Code");
      return;
    }

    try {
      isVerifyingOtp.value = true; // Show loading indicator on button
      
      // Fetch all leagues to find the one with matching leagueCode
      final response = await _repository.getAllLeague(limit: 200);
      
      response.fold(
        (fail) {
          setError("Failed to verify OTP: ${fail.message}");
          isVerifyingOtp.value = false;
        },
        (success) {
          // Check if we found a matching league (public or private)
          final isFound = success.data.any(
            (league) => league.leagueCode == otpController.text.trim()
          );

          if (isFound) {
            // Find the matching league
            final foundLeague = success.data.firstWhere(
              (league) => league.leagueCode == otpController.text.trim(),
            );

            // Auto-detect league type
            final leagueType = foundLeague.leagueType.toLowerCase();
            final isPublic = leagueType == 'public';

            // Store the league based on its type
            if (isPublic) {
              selectedPublicLeague.value = foundLeague;
            } else {
              selectedPrivateLeague.value = foundLeague;
            }
            
            selectedLeague.value = foundLeague.id;
            selectedLeagueType.value = leagueType;
            
            Get.back(result: true);
            clearError();
            isVerifyingOtp.value = false;
            
            // Show success message with league type detected
            Get.snackbar(
              'Success',
              '${isPublic ? 'Public' : 'Private'} league "${foundLeague.leagueName}" found! You can now complete your application.',
              backgroundColor: AppColors.primaryGreen.withOpacity(0.8),
              colorText: AppColors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
            
            DPrint.log("✅ League found and selected: ${foundLeague.leagueName} (${isPublic ? 'Public' : 'Private'})");
          } else {
            setError("Invalid OTP/League Code. Please check with the league organizer or owner.");
            isVerifyingOtp.value = false;
          }
        },
      );
    } catch (e) {
      setError("Error verifying OTP: $e");
      isVerifyingOtp.value = false;
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
