import 'package:app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class GoogleSignInButton extends ConsumerWidget {
  final Function()? onPressed;
  final String text;
  final bool disabled;
  final EdgeInsets padding;
  const GoogleSignInButton({
    required this.onPressed,
    required this.text,
    this.padding = EdgeInsets.zero,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return Container(
      padding: padding,
      height: 52,
      width: context.layout.maxWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          padding: EdgeInsets.zero,
          elevation: 2,
          backgroundColor:
              disabled ? const Color(0xff022C43) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        onPressed: disabled ? null : onPressed,
        child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          alignment: Alignment.center,
          width: context.layout.width,
          height: context.layout.height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(24.0),
            ),
            color: Color(0xffffffff),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Flexible(
                child: Image.asset(
                  'assets/google.png',
                  fit: BoxFit.cover,
                  height: 45,
                  width: 45,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: appTheme.textTheme.titleSmall!.copyWith(
                    color: const Color(0xff4285F4),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
