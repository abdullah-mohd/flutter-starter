import 'package:app/core/theme/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class AppButton extends ConsumerWidget {
  final Function()? onPressed;
  final String text;
  final Widget? prefix;
  final bool disabled;
  final EdgeInsets padding;
  final Color backgroundColor;
  final double borderRadius;
  final double height;
  final bool autoFocus;

  const AppButton({
    required this.onPressed,
    required this.text,
    this.prefix,
    this.backgroundColor = Colors.black,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 100,
    this.height = 52,
    this.disabled = false,
    this.autoFocus = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final appTheme = ref.watch(themeProvider).current.themeData;
    return Container(
      padding: padding,
      height: height,
      width: context.layout.maxWidth,
      child: ElevatedButton(
        autofocus: autoFocus,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 1,
          backgroundColor:
              disabled ? Color.fromARGB(255, 18, 99, 143) : Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: disabled
                  ? Colors.grey
                  : backgroundColor == Colors.black
                      ? Colors.white70
                      : Colors.black54,
              width: 0.25,
            ),
            borderRadius: BorderRadius.circular(
              100.0,
            ),
          ),
        ),
        onPressed: disabled ? null : onPressed,
        child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          alignment: Alignment.center,
          width: context.layout.width,
          height: context.layout.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
            color: disabled ? Colors.grey : backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefix != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: prefix,
                ),
              AppText(
                text,
                textAlign: TextAlign.center,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: backgroundColor == Colors.black
                    ? Colors.white
                    : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
