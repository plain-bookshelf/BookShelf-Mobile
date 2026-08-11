import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── 이름 설정 다이얼로그 ──────────────────────────────────────────────────────
class NicknameDialog extends StatefulWidget {
  final String currentNickname;
  final Future<void> Function(String nickname) onCheckDuplicate;
  final Future<void> Function(String newNickname) onConfirm;

  const NicknameDialog({
    super.key,
    required this.currentNickname,
    required this.onCheckDuplicate,
    required this.onConfirm,
  });

  @override
  State<NicknameDialog> createState() => _NicknameDialogState();
}

class _NicknameDialogState extends State<NicknameDialog> {
  late final _controller = TextEditingController(text: widget.currentNickname);
  bool _isSubmitting = false;
  bool _isChecking = false;
  bool _isAvailable = false;
  String? _checkMessage;

  bool get _isChanged =>
      _controller.text.trim().isNotEmpty &&
      _controller.text.trim() != widget.currentNickname;

  bool get _canConfirm => _isChanged && _isAvailable && !_isSubmitting;

  void _onTextChanged() {
    setState(() {
      _isAvailable = false;
      _checkMessage = null;
    });
  }

  Future<void> _onCheckDuplicate() async {
    final nickname = _controller.text.trim();
    if (!_isChanged) return;

    setState(() {
      _isChecking = true;
      _checkMessage = null;
    });
    try {
      await widget.onCheckDuplicate(nickname);
      if (!mounted) return;
      setState(() {
        _isChecking = false;
        _isAvailable = true;
        _checkMessage = '사용 가능한 이름입니다.';
      });
    } on DioException catch (e) {
      if (!mounted) return;
      final data = e.response?.data;
      final message = data is Map ? data['message'] as String? : null;
      setState(() {
        _isChecking = false;
        _isAvailable = false;
        _checkMessage = message ?? '이미 사용중인 이름입니다.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isChecking = false;
        _isAvailable = false;
        _checkMessage = '중복 확인에 실패했습니다. 다시 시도해주세요.';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      title: const Text(
        '이름 설정',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: '새 이름을 입력해주세요',
                    hintStyle: const TextStyle(color: AppColors.grey500),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.borderLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.successNormal,
                      ),
                    ),
                  ),
                  onChanged: (_) => _onTextChanged(),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _isChanged && !_isChecking
                    ? _onCheckDuplicate
                    : null,
                child: _isChecking
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        '중복확인',
                        style: TextStyle(
                          color: AppColors.successNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
          if (_checkMessage != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _checkMessage!,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isAvailable
                        ? AppColors.successNormal
                        : AppColors.errorNormal,
                  ),
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text(
            '취소',
            style: TextStyle(
              color: AppColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: _canConfirm
              ? () async {
                  setState(() => _isSubmitting = true);
                  await widget.onConfirm(_controller.text.trim());
                }
              : null,
          child: const Text(
            '확인',
            style: TextStyle(
              color: AppColors.successNormal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
