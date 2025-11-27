import 'package:flutter/material.dart';

class CreateLeagueDateLocationFields extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController locationController;
  final TextEditingController totalGameWeeksController;

  final VoidCallback? onSelectDate;

  const CreateLeagueDateLocationFields({
    super.key,
    required this.startDateController,
    required this.locationController,
    required this.totalGameWeeksController,
    this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildTextField(
                    "Start Date (YYYY-MM-DD)",
                    controller: startDateController,
                    readOnly: true,
                  ),
                  if (onSelectDate != null)
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onSelectDate,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: _buildTextField(
                "Total Game Weeks",
                controller: totalGameWeeksController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildTextField("Location", controller: locationController),
      ],
    );
  }

  // Reusable TextField
  Widget _buildTextField(
    String hint, {
    int maxLines = 1,
    double? fixedHeight,
    TextEditingController? controller,
    bool readOnly = false,
  }) {
    return SizedBox(
      height: fixedHeight ?? (maxLines > 1 ? null : 48),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
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
