import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  const BulletPoint({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffC9C9C9),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}