import 'package:flutter/material.dart';
import '../../models/edit_profile_model.dart';

class EditProfileInfoScreen extends StatelessWidget {
  final EditProfileModel member;

  const EditProfileInfoScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              'assets/icons/profile_Edit.png',
              width: 16,
              height: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 22, left: 24, right: 24, bottom: 24),
        child: Column(
          children: [
            // Circular Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(member.imageUrl),
            ),
            const SizedBox(height: 20),

            // 1st Row: First Name & Last Name
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: "First Name",
                    hintText: "Enter First Name",
                    initialValue: member.firstName,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: "Last Name",
                    hintText: "Enter Last Name",
                    initialValue: member.lastName,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 2nd Row: Email
            _buildTextField(
              label: "Email",
              hintText: "Enter Email",
              initialValue: member.email,
            ),
            const SizedBox(height: 16),

            // 3rd Row: Phone
            _buildTextField(
              label: "Phone",
              hintText: "Enter Phone Number",
              initialValue: member.phone,
            ),
            const SizedBox(height: 16),

            // 4th Row: Birthday
            _buildTextField(
              label: "Birthday",
              hintText: "Enter Birthday",
              initialValue: member.birthday,
            ),
            const SizedBox(height: 16),

            // 5th Row: Gender
            _buildTextField(
              label: "Gender",
              hintText: "Enter Gender",
              initialValue: member.gender,
            ),
            const SizedBox(height: 30),

            // Last Row: Save Button
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable TextField Builder
  Widget _buildTextField({
    required String label,
    required String hintText,
    required String initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label on top
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: TextFormField(
            initialValue: initialValue,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(4),
              ),
              fillColor: Colors.grey[900],
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
