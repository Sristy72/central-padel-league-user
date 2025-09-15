// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PlayingLevelDropdown extends StatelessWidget {
//   final controller = Get.put(PlayingLevelController());

//   PlayingLevelDropdown({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return DropdownButtonFormField<String>(
//         value: controller.selectedLevel.value.isEmpty
//             ? null
//             : controller.selectedLevel.value,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: const Color(0xFF2C2C2C),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         hint: const Text(
//           "Enter your playing level",
//           style: TextStyle(color: Colors.white70, fontSize: 14),
//         ),
//         dropdownColor: const Color(0xFF2C2C2C),
//         icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//         style: const TextStyle(color: Colors.white, fontSize: 14),
//         items: controller.levels
//             .map((level) => DropdownMenuItem(
//                   value: level,
//                   child: Text(level),
//                 ))
//             .toList(),
//         onChanged: (value) {
//           controller.selectedLevel.value = value ?? '';
//         },
//       );
//     });
//   }
// }
