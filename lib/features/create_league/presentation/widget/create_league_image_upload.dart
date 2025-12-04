import 'dart:io';
import 'package:flutter/material.dart';

class CreateLeagueImageUpload extends StatelessWidget {
  final File? logoImage;
  final File? bannerImage;
  final VoidCallback onPickLogo;
  final VoidCallback onPickBanner;

  const CreateLeagueImageUpload({
    super.key,
    required this.logoImage,
    required this.bannerImage,
    required this.onPickLogo,
    required this.onPickBanner,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload your logo/photo",
          style: TextStyle(
            color: Color(0xFFD7D7D7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        _imageUploadBox1(isLogo: true),
        const SizedBox(height: 12),
        const Text(
          "Tournament Banner Image Upload",
          style: TextStyle(
            color: Color(0xFFD7D7D7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        _imageUploadBox(isLogo: false),
      ],
    );
  }

  // Image Upload Box for banner
  Widget _imageUploadBox({required bool isLogo}) {
    final file = isLogo ? logoImage : bannerImage;
    return GestureDetector(
      onTap: isLogo ? onPickLogo : onPickBanner,
      child: Container(
        height: 105,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF050505),
          borderRadius: BorderRadius.circular(4),
        ),
        child: file == null
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
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
          ],
        )
            : Image.file(file, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }

  // Image Upload Box for logo
  Widget _imageUploadBox1({required bool isLogo}) {
    final file = isLogo ? logoImage : bannerImage;
    return GestureDetector(
      onTap: isLogo ? onPickLogo : onPickBanner,
      child: Container(
        height: 105,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF3C3C3C),
          borderRadius: BorderRadius.circular(4),
        ),
        child: file == null
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
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
          ],
        )
            : Image.file(file, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }
}