import 'package:flutter/material.dart';

class SocialDivider extends StatelessWidget {
  const SocialDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFDDDDDD), thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '소셜 로그인',
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFDDDDDD), thickness: 1)),
      ],
    );
  }
}
