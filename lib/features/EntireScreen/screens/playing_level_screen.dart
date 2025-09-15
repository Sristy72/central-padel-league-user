// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:karlfive/features/EntireScreen/widgets/custom_card_widget.dart';
// import '../controllers/playing_level_controller.dart';
// import '../widgets/custom_card.dart';
// import '../widgets/playing_level_dropdown.dart';

// class PlayingLevelScreen extends StatelessWidget {
//   const PlayingLevelScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(PlayingLevelController());

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Progress bar
//               LinearProgressIndicator(
//                 value: 0.25, // progress step
//                 color: Colors.green,
//                 backgroundColor: Colors.white24,
//                 minHeight: 6,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               const SizedBox(height: 40),

//               // Card with dropdown
//               CustomCardWidget(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Your playing level",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     PlayingLevelDropdown(),
//                   ],
//                 ),
//               ),

//               const Spacer(),

//               // Next button
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (controller.selectedLevel.value.isEmpty) {
//                       Get.snackbar("Error", "Please select your playing level",
//                           snackPosition: SnackPosition.BOTTOM,
//                           backgroundColor: Colors.red,
//                           colorText: Colors.white);
//                     } else {
//                       // navigate to next step
//                       // Get.to(() => NextScreen());
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text("Next"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
