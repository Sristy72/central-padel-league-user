import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/edit_profile_model.dart';
import '../../data/models/team_member_model.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/profile_controller.dart';
import 'profile_info_screen.dart';

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
  late final ProfileController _profileController;

  // Method to clear all form fields (except email which is uneditable)
  void _clearAllFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    _birthdayController.clear();
    setState(() {
      _selectedGender = "";
      _pickedImage = null;
    });
  }



  @override
  void initState() {
    super.initState();
    // Show existing profile data as hint text; leave fields empty so user can type.
    _birthdayController = TextEditingController(text: '');
    _firstNameController = TextEditingController(text: '');
    _lastNameController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');
    _controller = Get.find<EditProfileController>();
    _profileController = Get.find<ProfileController>();
    // prefer profile values when available for initial hinting
    _selectedGender = _profileController.profile.value?.gender ?? widget.member.gender;

    // Set email from profile controller (uneditable)
    _emailController = TextEditingController(
        text: _profileController.profile.value?.email ?? widget.member.email
    );
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
                    Builder(builder: (_) {
                      final profileImg = _profileController.profile.value?.profileImage ?? '';
                      final fallback = widget.member.imageUrl;
                      ImageProvider display;
                      if (_pickedImage != null) {
                        display = FileImage(_pickedImage!);
                      } else if (profileImg.isNotEmpty) {
                        display = profileImg.startsWith('http') ? NetworkImage(profileImg) : AssetImage(profileImg);
                      } else if (fallback.isNotEmpty) {
                        display = fallback.startsWith('http') ? NetworkImage(fallback) : AssetImage(fallback);
                      } else {
                        display = const AssetImage('assets/images/profile.png');
                      }

                      return CircleAvatar(
                        radius: 55,
                        backgroundImage: display,
                      );
                    }),
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
                      hintText: (_profileController.profile.value?.name != null && _profileController.profile.value!.name!.isNotEmpty)
                          ? _profileController.profile.value!.name!.split(' ').first
                          : (widget.member.firstName.isNotEmpty ? widget.member.firstName : 'First Name'),
                      controller: _firstNameController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Last Name",
                      hintText: (_profileController.profile.value?.name != null && _profileController.profile.value!.name!.isNotEmpty && _profileController.profile.value!.name!.split(' ').length > 1)
                          ? _profileController.profile.value!.name!.split(' ').sublist(1).join(' ')
                          : (widget.member.lastName.isNotEmpty ? widget.member.lastName : 'Last Name'),
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
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Phone
              _buildTextField(
                label: "Phone",
                hintText: _profileController.profile.value?.phoneNumber?.isNotEmpty == true
                    ? _profileController.profile.value!.phoneNumber!
                    : (widget.member.phone.isNotEmpty ? widget.member.phone : 'Enter Phone Number'),
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
                        hintText: widget.member.birthday.isNotEmpty ? widget.member.birthday : '29/02/2000',
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
                      initialValue: null,
                      hint: Text(
                        _profileController.profile.value?.gender?.isNotEmpty == true
                            ? _profileController.profile.value!.gender!
                            : (widget.member.gender.isNotEmpty ? widget.member.gender : 'Select'),
                        style: const TextStyle(color: Colors.white),
                      ),
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
                      final rawFirst = _firstNameController.text.trim();
                      final rawLast = _lastNameController.text.trim();
                      final email = _emailController.text.trim();
                      final rawPhone = _phoneController.text.trim();
                      final rawBirthday = _birthdayController.text.trim();
                      final rawGender = _selectedGender;

                      // Use existing member/profile values as fallback when fields left empty
                      final profileVal = _profileController.profile.value;
                      final firstName = rawFirst.isNotEmpty
                          ? rawFirst
                          : (widget.member.firstName.isNotEmpty
                          ? widget.member.firstName
                          : (profileVal?.name?.split(' ').first ?? ''));
                      final lastName = rawLast.isNotEmpty
                          ? rawLast
                          : (widget.member.lastName.isNotEmpty
                          ? widget.member.lastName
                          : (profileVal?.name?.split(' ').length ?? 0) > 1
                          ? profileVal!.name!.split(' ').sublist(1).join(' ')
                          : '');

                      final phone = rawPhone.isNotEmpty ? rawPhone : (widget.member.phone.isNotEmpty ? widget.member.phone : (profileVal?.phoneNumber ?? ''));
                      final birthday = rawBirthday.isNotEmpty ? rawBirthday : (widget.member.birthday.isNotEmpty ? widget.member.birthday : '');
                      final gender = rawGender.isNotEmpty ? rawGender : (widget.member.gender.isNotEmpty ? widget.member.gender : (profileVal?.gender ?? ''));

                      // Basic validation
                      if (firstName.isEmpty || lastName.isEmpty) {
                        Get.snackbar(
                          'Validation Error',
                          'First name and last name are required',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                          margin: const EdgeInsets.all(16),
                          borderRadius: 8,
                        );
                        return;
                      }

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
                        // Clear all form fields after successful update
                        _clearAllFields();

                        // Refresh global profile data so profile screen shows updates
                        final profileCtrl = Get.find<ProfileController>();
                        await profileCtrl.fetchProfile();

                        // Build a TeamMemberModel from updated profile and navigate to ProfileInfoScreen
                        final updated = profileCtrl.profile.value;
                        final memberModel = TeamMemberModel(
                          id: updated?.id ?? '',
                          name: updated?.name ?? '${firstName} ${lastName}',
                          role: updated?.role ?? '',
                          imageUrl: updated?.profileImage ?? widget.member.imageUrl,
                          matches: 0,
                          level: int.tryParse(updated?.playingLevel ?? '') ?? 1,
                          firstName: firstName,
                          lastName: lastName,
                          email: updated?.email ?? email,
                          phone: updated?.phoneNumber ?? phone,
                          birthday: birthday,
                          gender: updated?.gender ?? gender,
                        );

                        // Navigate to the profile screen replacing the current edit page
                        Get.off(() => ProfileInfoScreen(member: memberModel));
                      }
                      // Error handling is already done by the controller with snackbars
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
    bool enabled = true,
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
            enabled: enabled,
            style: TextStyle(
                color: enabled ? Colors.white : Colors.grey,
                fontSize: 14
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                  color: Color(0xFF7D807D), fontSize: 16),
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: enabled ? Colors.white : Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: enabled ? Colors.white : Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
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