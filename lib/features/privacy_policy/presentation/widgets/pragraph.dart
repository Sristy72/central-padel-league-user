import 'package:flutter/material.dart';

class Pragraph extends StatelessWidget {
  const Pragraph({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xffC9C9C9),
        height: 1.5,
      ),
    );
  }
}