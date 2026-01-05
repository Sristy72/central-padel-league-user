import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../league/presentation/screens/leagues_screen.dart';
import '../controller/create_league_controller.dart';
import '../widget/create_league_appbar_widget.dart';
import '../widget/create_league_date_location.dart';
import '../widget/create_league_form_fields.dart';
import '../widget/create_league_image_upload.dart';
import '../widget/create_league_rule_selection.dart';
import '../widget/create_league_selection_button.dart';
import '../widget/private_league_validation.dart';

class CreateLeagueScreen extends StatefulWidget {
  const CreateLeagueScreen({super.key});

  @override
  State<CreateLeagueScreen> createState() => _CreateLeagueScreenState();
}

class _CreateLeagueScreenState extends State<CreateLeagueScreen> {
  final CreateLeagueController controller = Get.put(CreateLeagueController());

  final TextEditingController _leagueNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _totalGameWeeksController = TextEditingController(
    text: '0',
  );
  final TextEditingController _entryFeeController = TextEditingController();

  File? logoImage;
  File? bannerImage;

  String _selectedType = 'Singles';
  String _selectedMatchFormat = 'Best of 3 sets';
  String _selectedTiebreak = 'Standard 7-point';
  String _selectedMatchPlay = 'Once';
  String _selectedLeagueType = 'Public';
  bool _allowSubstitutes = false;

  // --------------------------- IMAGE PICKER ---------------------------
  Future<void> _pickImage(bool isLogo) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isLogo) {
          logoImage = File(pickedFile.path);
        } else {
          bannerImage = File(pickedFile.path);
        }
      });
    }
  }

  // --------------------------- DATE PICKER ---------------------------
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _startDateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  // --------------------------- BUILD UI ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: const CreateLeagueAppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 13,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateLeagueFormFields(
              leagueNameController: _leagueNameController,
              descriptionController: _descriptionController,
            ),
            const SizedBox(height: 16),

            CreateLeagueImageUpload(
              logoImage: logoImage,
              bannerImage: bannerImage,
              onPickLogo: () => _pickImage(true),
              onPickBanner: () => _pickImage(false),
            ),

            const SizedBox(height: 16),

            CreateLeagueDateLocationFields(
              startDateController: _startDateController,
              locationController: _locationController,
              totalGameWeeksController: _totalGameWeeksController,
              onSelectDate: () => _selectDate(context),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _entryFeeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Add Entry Fee",
                hintStyle: const TextStyle(
                  color: Color(0xFFCACACA),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.grey[900],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),

            const SizedBox(height: 24),

            CreateLeagueSelectionButtons(
              selectedType: _selectedType,
              selectedMatchFormat: _selectedMatchFormat,
              selectedTiebreak: _selectedTiebreak,
              allowSubstitutes: _allowSubstitutes,
              selectedMatchPlay: _selectedMatchPlay,
              selectedLeagueType: _selectedLeagueType,
              onTypeChanged: (type) => setState(() => _selectedType = type),
              onMatchFormatChanged: (format) =>
                  setState(() => _selectedMatchFormat = format),
              onTiebreakChanged: (tiebreak) =>
                  setState(() => _selectedTiebreak = tiebreak),
              onAllowSubstitutesChanged: (allow) =>
                  setState(() => _allowSubstitutes = allow),
              onMatchPlayChanged: (matchPlay) =>
                  setState(() => _selectedMatchPlay = matchPlay),
              onLeagueTypeChanged: (leagueType) =>
                  setState(() => _selectedLeagueType = leagueType),
            ),

            const SizedBox(height: 16),

            const CreateLeagueRulesSection(),

            const SizedBox(height: 43),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 116,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: () {
                      handleCreate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Obx(
                      () => controller.isLoading.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              "Publish",
                              style: TextStyle(
                                color: Color(0xFF141414),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),

        

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --------------------------- CREATE HANDLER ---------------------------
  void handleCreate() async {
    // Basic validation
    if (_leagueNameController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a league name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_startDateController.text.trim().isEmpty) {
      Get.snackbar(
        "Error", 
        "Please select a start date",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }


    if (_locationController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a location", 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Call the actual API
    final response = await controller.createLeague(
      leagueName: _leagueNameController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDateController.text.trim(),
      location: _locationController.text.trim(),
      totalGameWeeks: int.tryParse(_totalGameWeeksController.text) ?? 0,
      type: _selectedType,
      leagueType: _selectedLeagueType.toLowerCase(),
      matchFormat: _selectedMatchFormat,
      tiebreakOption: _selectedTiebreak,
      allowSubstitutes: _allowSubstitutes,
      matchPlay: _selectedMatchPlay.toLowerCase(),
      entryFee: _entryFeeController.text.trim(),
    );

    if (response != null) {
      // Success
      if (_selectedLeagueType.toLowerCase() == 'private') {
        // Show the Private League dialog with the actual league code
        showDialog(
          context: context,
          builder: (context) => PrivateLeagueCodeDialog(
            leagueCode: response.leagueCode,
          ),
        );
      } else {
        // For public league, show success message and navigate to Main League tab
        Get.snackbar(
          "Success",
          "League '${response.leagueName}' created successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigate to Main League tab to show the newly created public league
        Get.offAll(() => const LeaguesScreen(
          leagueType: 'public',
          limit: 200,
        ));
      }
    } else {
      // Error is already handled in the controller and displayed
      // Just show a generic fallback message if needed
      if (controller.errorMessage.value.isEmpty) {
        Get.snackbar(
          "Error",
          "Failed to create league. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          controller.errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

}
