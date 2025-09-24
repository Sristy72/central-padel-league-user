import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../controllers/edit_profile_controller.dart';
import '../controllers/profile_controller.dart';

import '../../data/models/edit_profile_model.dart';

class EditProfileInfoScreen extends StatefulWidget {
  final EditProfileModel member;

  const EditProfileInfoScreen({super.key, required this.member});

  @override
  State<EditProfileInfoScreen> createState() => _EditProfileInfoScreenState();
}

class _EditProfileInfoScreenState extends State<EditProfileInfoScreen> {
  late TextEditingController _birthdayController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String _selectedGender = "";
  File? _pickedImage;
  late final EditProfileController _controller;

  @override
  void initState() {
    super.initState();
    _birthdayController = TextEditingController(text: widget.member.birthday);
    _selectedGender = widget.member.gender;
    _firstNameController = TextEditingController(text: widget.member.firstName);
    _lastNameController = TextEditingController(text: widget.member.lastName);
    _emailController = TextEditingController(text: widget.member.email);
    _phoneController = TextEditingController(text: widget.member.phone);
    _controller = Get.find<EditProfileController>();
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Date Picker
  Future<void> _selectDate() async {
    DateTime initialDate =
        DateTime.tryParse(_birthdayController.text) ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.black),
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

  // Image Picker
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black12,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.green),
              title: const Text("Gallery"),
                onTap: () {
                _pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text("Camera"),
              onTap: () {
                _pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
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
          padding:
          const EdgeInsets.only(top: 22, left: 24, right: 24, bottom: 24),
          child: Column(
            children: [
              // Profile Image with picker
              GestureDetector(
                onTap: _showImagePickerDialog,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : AssetImage(widget.member.imageUrl) as ImageProvider,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // First Name & Last Name
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "First Name",
                      hintText: "Ken",
                      controller: _firstNameController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Last Name",
                      hintText: "Adams",
                      controller: _lastNameController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email
              _buildTextField(
                label: "Email",
                hintText: "Enter Email",
                controller: _emailController,
              ),
              const SizedBox(height: 16),

              // Phone
              _buildTextField(
                label: "Phone",
                hintText: "Enter Phone Number",
                controller: _phoneController,
              ),
              const SizedBox(height: 16),

              // Birthday with calendar icon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Birthday",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: TextFormField(
                      controller: _birthdayController,
                      readOnly: true,
                      onTap: _selectDate,
                      style:
                      const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "29/02/2000",
                        hintStyle: const TextStyle(
                            color: Color(0xFF7D807D), fontSize: 16),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
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
                            "assets/icons/editProfile_Calendar.png",
                            width: 16,
                            height: 16,
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
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: DropdownButtonFormField<String>(
                      initialValue:
                      _selectedGender.isNotEmpty ? _selectedGender : null,
                      dropdownColor: Colors.black,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      icon: const Icon(Icons.keyboard_arrow_down_sharp,
                          color: Color(0xFF7D807D)),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
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
                        child: Text(gender,
                            style:
                            const TextStyle(color: Colors.white)),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final firstName = _firstNameController.text;
                      final lastName = _lastNameController.text;
                      final email = _emailController.text;
                      final phone = _phoneController.text;
                      final birthday = _birthdayController.text;
                      final gender = _selectedGender;

                      final success = await _controller.updateProfile(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        phone: phone,
                        birthday: birthday,
                        gender: gender,
                        image: _pickedImage,
                      );

                      if (success) {
                        // Refresh global profile data so profile screen shows updates
                        final profileCtrl = Get.find<ProfileController>();
                        await profileCtrl.fetchProfile();
                        Get.back();
                      }
                    },
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

  // Reusable TextField Builder
  Widget _buildTextField({
    required String label,
    required String hintText,
    String? initialValue,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 38,
          child: TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                  color: Color(0xFF7D807D), fontSize: 16),
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
