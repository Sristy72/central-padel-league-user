import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../home/presentation/screens/home_screen.dart';

class PrivateLeagueCodeDialog extends StatefulWidget {
  final String leagueCode;

  const PrivateLeagueCodeDialog({
    super.key,
    required this.leagueCode,
  });

  @override
  State<PrivateLeagueCodeDialog> createState() =>
      _PrivateLeagueCodeDialogState();
}

class _PrivateLeagueCodeDialogState extends State<PrivateLeagueCodeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      actionsPadding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
      title: const Text(
        'Use this key to join this league',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.leagueCode,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () async {
                    // Copy to clipboard
                    await Clipboard.setData(
                      ClipboardData(text: widget.leagueCode),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copied to clipboard!'),
                          backgroundColor: Color(0xFF2AAF08),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.copy,
                    color: Color(0xFF2AAF08),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.offAll(() => const HomeScreen());
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF2AAF08),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
