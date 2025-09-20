import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../controllers/report_controller.dart';

class ProfileReportScreen extends StatefulWidget {
  const ProfileReportScreen({super.key});

  @override
  State<ProfileReportScreen> createState() => _ProfileReportScreenState();
}

class _ProfileReportScreenState extends State<ProfileReportScreen> {
  final reportController = Get.find<ReportController>();

  final TextEditingController eventController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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

  void _submitReport() async {
    reportController.createReport(
      userId: "68ccd4854f2b792c1ee5a84a",
      even: eventController.text,
      description: descriptionController.text,
      imageFile: _selectedImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Report",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
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
              const Text("Event", style: TextStyle(color: Color(0xFFF5F5F5), fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: eventController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                  fillColor: Colors.black,
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              const Text("Description", style: TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(height: 6),
              TextFormField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Write here",
                  hintStyle: TextStyle(color: Color(0xFFA7A7A7), fontSize: 14),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
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
                      Image.asset('assets/icons/Report_drop_photo.png',
                          width: 17, height: 17, color: Colors.white),
                      const SizedBox(height: 7),
                      const Text("Drop your files here", style: TextStyle(color: Colors.white, fontSize: 8)),
                      const SizedBox(height: 10),
                      const Text("Choose File", style: TextStyle(color: Colors.blue, fontSize: 8)),
                    ],
                  )
                      : Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity),
                ),
              ),

              const SizedBox(height: 16),

              // Submit Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B7FD0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: reportController.isLoading.value ? null : _submitReport,
                  child: reportController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
