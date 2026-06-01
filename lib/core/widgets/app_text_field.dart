import 'package:bookshelf_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 앱 전체 공용 텍스트 입력 필드
class AppTextField extends StatefulWidget {
  final String? hintText;
  final String? label;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    this.hintText,
    this.label,
    this.controller,
    this.errorText,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _internalController;

  TextEditingController get _controller =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    if (widget.controller == null) {
      _internalController.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }

  bool get _hasText => _controller.text.isNotEmpty;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: const TextStyle(color: AppColors.textDark, fontSize: 16),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppColors.grey500, fontSize: 14),
            filled: true,
            fillColor: AppColors.grey200,
            errorText: widget.errorText,
            suffixIcon: widget.suffixIcon,
            suffixIconConstraints: widget.suffixIconConstraints,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: _border(AppColors.borderNormal),
            enabledBorder: _border(
              _hasText ? AppColors.textDark : AppColors.borderNormal,
            ),
            focusedBorder: _border(AppColors.successNormal),
            errorBorder: _border(AppColors.errorNormal),
            focusedErrorBorder: _border(AppColors.errorNormal),
            errorStyle:
                const TextStyle(color: AppColors.errorNormal, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
