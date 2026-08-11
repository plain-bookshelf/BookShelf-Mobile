import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// 오류 내용을 알려주는 모달 다이얼로그
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;

  const ErrorDialog({
    super.key,
    required this.message,
    this.title = '오류',
    this.confirmLabel = '확인',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.errorNormal,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: AppColors.grey700,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            confirmLabel,
            style: const TextStyle(
              color: AppColors.errorNormal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// 오류 모달을 띄운다. 닫힐 때까지 대기.
Future<void> showErrorDialog(
  BuildContext context, {
  required String message,
  String title = '오류',
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => ErrorDialog(title: title, message: message),
  );
}
