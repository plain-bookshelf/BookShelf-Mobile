import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const TextLink({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
      ),
    );
  }
}
