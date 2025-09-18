import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileReportScreen extends StatefulWidget {
  const ProfileReportScreen({super.key});

  @override
  State<ProfileReportScreen> createState() => _ProfileReportScreenState();
}

class _ProfileReportScreenState extends State<ProfileReportScreen> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event
              const Text(
                "Event",
                style: TextStyle(color: Color(0xFFF5F5F5), fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  fillColor: Colors.black,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              const Text(
                "Description",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 6),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Write here",
                  hintStyle: const TextStyle(color: Color(0xFFA7A7A7), fontSize: 14),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  fillColor: Colors.black,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),

              // File Upload Section
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: _selectedImage == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/Report_drop_photo.png',
                        width: 17,
                        height: 17,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "Drop your files here",
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Choose File",
                        style: TextStyle(color: Colors.blue, fontSize: 8),
                      ),
                    ],
                  )
                      : Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
