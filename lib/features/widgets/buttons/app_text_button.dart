import 'package:app/core/theme/app_text.dart';
import 'package:app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class AppTextButton extends ConsumerWidget {
  final Function()? onPressed;
  final EdgeInsets padding;
  final String label;
  final Color textColor;
  final TextDecoration textDecor;

  const AppTextButton({
    this.onPressed,
    required this.label,
    this.textDecor = TextDecoration.none,
    this.padding = EdgeInsets.zero,
    this.textColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return Container(
      height: 40,
      width: context.layout.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: appTheme.colorScheme.secondary.withAlpha(20),
      ),
      margin: padding,
      child: TextButton(
        onPressed: onPressed,
        child: AppText(
          label,
          color: textColor,
        ),
      ),
    );
  }
}
