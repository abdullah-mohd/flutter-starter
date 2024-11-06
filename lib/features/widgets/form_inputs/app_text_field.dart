import 'package:layout/layout.dart';
import 'package:app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppTextField extends ConsumerWidget {
  final Function(String) onChanged;
  final Function(String?)? onSaved;

  final String label;
  final String hint;
  final bool obscureText;
  final TextInputAction? action;
  final Widget? suffixIcon;
  final String? value;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.onChanged,
    required this.onSaved,
    required this.label,
    required this.hint,
    this.action,
    this.maxLines = 1,
    this.value,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return Container(
      width: context.layout.width,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black26,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.988),
          )
        ],
      ),
      child: TextFormField(
        textInputAction: action,
        initialValue: value,
        validator: validator,
        obscureText: obscureText,
        maxLines: maxLines,
        key: Key(label.toLowerCase()),
        onSaved: onSaved,
        onChanged: (value) => onChanged(value),
        autocorrect: false,
        style: appTheme.textTheme.bodySmall!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          filled: true,
          suffixIcon: suffixIcon,
          fillColor: const Color(0xfff3f3f3),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.transparent,
            ),
          ),
          labelText: label,
          alignLabelWithHint: true,
          labelStyle: appTheme.textTheme.bodySmall!.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          hintText: hint,
          hintStyle: appTheme.textTheme.bodySmall!.copyWith(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
