import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:bookshelf_mobile/core/network/api_error.dart';
import 'package:bookshelf_mobile/core/router/app_router.dart';
import 'package:bookshelf_mobile/core/router/route_extras.dart';
import 'package:bookshelf_mobile/core/widgets/app_elevated_button.dart';
import 'package:bookshelf_mobile/core/widgets/app_text_field.dart';
import 'package:bookshelf_mobile/core/widgets/error_dialog.dart';
import 'package:bookshelf_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bookshelf_mobile/features/auth/presentation/providers/find_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FindPasswordVerifyPage extends ConsumerStatefulWidget {
  final String email;

  const FindPasswordVerifyPage({super.key, required this.email});

  @override
  ConsumerState<FindPasswordVerifyPage> createState() =>
      _FindPasswordVerifyPageState();
}

class _FindPasswordVerifyPageState
    extends ConsumerState<FindPasswordVerifyPage> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onNext(String code) async {
    try {
      final registerToken = await ref
          .read(authRepositoryProvider)
          .findPassword(email: widget.email, verificationCode: code);
      if (!mounted) return;
      context.push(
        AppRoutes.changePassword,
        extra: ChangePasswordExtra(
          registerToken: registerToken,
          email: widget.email,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      await showErrorDialog(
        context,
        title: '인증 실패',
        message: parseApiErrorMessage(e, fallback: '인증코드가 올바르지 않습니다.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(findPasswordVerifyProvider);
    final notifier = ref.read(findPasswordVerifyProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF7E7E7E),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                '인증번호 확인',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.successNormal,
                ),
              ),
              const SizedBox(height: 32),
              AppTextField(
                hintText: '인증번호 입력',
                controller: _codeController,
                onChanged: (v) {
                  notifier.updateCode(v);
                  setState(() {});
                },
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    timerState.timerText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.errorNormal,
                    ),
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(minHeight: 0),
              ),
              const Spacer(),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '인증번호가 오지 않는다면 ',
                      style: TextStyle(fontSize: 14, color: AppColors.grey600),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _codeController.clear();
                        notifier.resend();
                        try {
                          await ref
                              .read(authRepositoryProvider)
                              .sendFindPasswordEmail(widget.email);
                        } catch (_) {}
                      },
                      child: const Text(
                        '재전송',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.successNormal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppElevatedButton(
                onPressed: timerState.canSubmit
                    ? () => _onNext(timerState.code)
                    : null,
                label: '다음',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
