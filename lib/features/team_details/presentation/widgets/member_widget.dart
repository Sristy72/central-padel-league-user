import 'package:flutter/material.dart';

Widget buildMember(String imgPath, String name) {
  return Column(
    children: [
      CircleAvatar(
        radius: 35,
        backgroundImage: AssetImage(imgPath),
      ),
      const SizedBox(height: 5),
      Text(
        name,
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
