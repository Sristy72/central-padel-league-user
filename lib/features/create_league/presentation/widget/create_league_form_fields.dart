import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CreateLeagueFormFields extends StatelessWidget {
  final TextEditingController leagueNameController;
  final TextEditingController descriptionController;

  const CreateLeagueFormFields({
    super.key,
    required this.leagueNameController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          "Enter League Name",
          controller: leagueNameController,
        ),
        const SizedBox(height: 8),
        _buildTextField(
          "Enter league description",
          maxLines: 8,
          fixedHeight: 183,
          controller: descriptionController,
        ),
        const SizedBox(height: 27),
        // Removed Row with Start Date and Total Game Weeks fields, and the Location field from here
      ],
    );
  }

  // Reusable TextField
  Widget _buildTextField(String hint, {
    int maxLines = 1,
    double? fixedHeight,
    TextEditingController? controller,
  }) {
    return SizedBox(
      height: fixedHeight ?? (maxLines > 1 ? null : 48),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: _fieldDecoration(hint),
      ),
    );
  }

  // Decoration
  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
  }
}