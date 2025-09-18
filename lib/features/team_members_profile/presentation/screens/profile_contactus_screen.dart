import 'package:flutter/material.dart';
import '../../models/edit_profile_model.dart';

class ProfileContactUsScreen extends StatelessWidget {
  final EditProfileModel member;

  const ProfileContactUsScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Contact Us",
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
              // First + Last Name
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: "First Name*",
                      hintText: "Enter Your Surname",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: "Last Name*",
                      hintText: "Enter Your Last Name",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Address
              _buildTextField(
                label: "Address",
                hintText: "Enter Your Address",
              ),
              const SizedBox(height: 10),

              // Phone
              _buildTextField(
                label: "Phone Number",
                hintText: "Enter Phone Number",
              ),
              const SizedBox(height: 10),

              // Subject
              _buildTextField(
                label: "Subject",
                hintText: "Enter Here",
              ),
              const SizedBox(height: 10),

              // Your Company (large height)
              _buildTextField(
                label: "Your Company",
                hintText: "Tell us how we can help you",
                maxLines: 8,
              ),
              const SizedBox(height: 43),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/contactus_mail.png",
                          width: 35,
                          height: 35,

                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'example@gmail.com',
                          style: TextStyle(
                            color: Color(0xFFA7A7A7), // আগের hintText এর রঙ
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // Phone
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/contactus_phone.png",
                          width: 35,
                          height: 35,

                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '+880 1234 567890',
                          style: TextStyle(
                            color: Color(0xFFA7A7A7),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // Address
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/contactus_location.png",
                          width: 35,
                          height: 35,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '123, Main Street, Dhaka',
                          style: TextStyle(
                            color: Color(0xFFA7A7A7),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),

                    // Time
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/contactus_clock.png",
                          width: 35,
                          height: 35,

                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'www.example.com',
                          style: TextStyle(
                            color: Color(0xFFA7A7A7),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),

                  ],
                ),
              ),



              const SizedBox(height: 43),

              // Submit Button
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 39,
                  width: 342,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B7FD0),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Sent Message",
                      style: TextStyle(
                        color: Colors.white,
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
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF5F5F5),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          style: const TextStyle(color: Color(0xFFA7A7A7), fontSize: 12, fontWeight: FontWeight.w400),
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFFA7A7A7), fontSize: 12),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF484848)),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(6),
            ),
            fillColor: Colors.grey[900],
            filled: true,
          ),
        ),
      ],
    );
  }
}
