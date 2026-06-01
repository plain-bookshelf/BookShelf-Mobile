import 'package:flutter/material.dart';

/// 소셜 로그인 버튼 (카카오 / 네이버 / 구글)
class SocialLoginButton extends StatelessWidget {
  final String logoAsset;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const SocialLoginButton({
    super.key,
    required this.logoAsset,
    required this.label,
    required this.backgroundColor,
    this.textColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11.5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: backgroundColor == Colors.white
              ? Border.all(color: const Color(0xFFDDDDDD))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(logoAsset, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
