import 'package:flutter/material.dart';
import '../../models/edit_profile_model.dart';

class EditProfileInfoScreen extends StatefulWidget {
  final EditProfileModel member;

  const EditProfileInfoScreen({super.key, required this.member});

  @override
  State<EditProfileInfoScreen> createState() => _EditProfileInfoScreenState();
}

class _EditProfileInfoScreenState extends State<EditProfileInfoScreen> {
  late TextEditingController _birthdayController;
  String _selectedGender = "";

  @override
  void initState() {
    super.initState();
    _birthdayController = TextEditingController(text: widget.member.birthday);
    _selectedGender = widget.member.gender;
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  // 🔹 Date Picker
  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.tryParse(_birthdayController.text) ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.black,
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _birthdayController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 22, left: 24, right: 24, bottom: 24),
          child: Column(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(widget.member.imageUrl),
              ),
              const SizedBox(height: 20),

              // First Name & Last Name
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "First Name",
                      hintText: "Ken",
                      initialValue: widget.member.firstName,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Last Name",
                      hintText: "Adams",
                      initialValue: widget.member.lastName,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email
              _buildTextField(
                label: "Email",
                hintText: "Enter Email",
                initialValue: widget.member.email,
              ),
              const SizedBox(height: 16),

              // Phone
              _buildTextField(
                label: "Phone",
                hintText: "Enter Phone Number",
                initialValue: widget.member.phone,
              ),
              const SizedBox(height: 16),

              // Birthday with calendar icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Birthday",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: TextFormField(
                      controller: _birthdayController,
                      readOnly: true,
                      onTap: _selectDate,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "29/02/1555",
                        hintStyle: const TextStyle(color: Color(0xFF7D807D), fontSize: 16),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        fillColor: Colors.grey[900],
                        filled: true,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/icons/editProfile_Calendar.png", width: 16,height: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Gender
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Gender",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender.isNotEmpty ? _selectedGender : null,
                      dropdownColor: Colors.black,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      icon: const Icon(Icons.keyboard_arrow_down_sharp, color: Color(0xFF7D807D)),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        fillColor: Colors.grey[900],
                        filled: true,
                      ),
                      items: ["Male", "Female", "Other"]
                          .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender, style: const TextStyle(color: Colors.white)),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value ?? "";
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 39,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Color(0xFF060606),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Reusable TextField Builder
  Widget _buildTextField({
    required String label,
    required String hintText,
    required String initialValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: TextFormField(
            initialValue: initialValue,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFF7D807D), fontSize: 16),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
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
