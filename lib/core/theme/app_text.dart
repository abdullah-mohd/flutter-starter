import 'package:app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Map fontFamilies = {
  "stretchPro": "Stretch Pro",
  "proxNova": "Proxima Nova",
  "joyride": "JoyRide",
};

class AppText extends ConsumerWidget {
  final String text;
  final String variant;
  final Color color;
  final TextAlign textAlign;
  final double? lineHeight;
  final EdgeInsets? padding;
  final FontWeight? fontWeight;
  final double? fontSize;
  final int? maxLines;
  final String fontFamily;

  const AppText(
    this.text, {
    this.color = Colors.black,
    this.variant = 'bodyMedium',
    this.textAlign = TextAlign.start,
    this.padding = EdgeInsets.zero,
    this.fontFamily = 'Stretch Pro',
    this.maxLines,
    this.lineHeight,
    this.fontWeight,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;

    TextStyle textStyle;
    switch (variant) {
      case 'titleMedium':
        textStyle = appTheme.textTheme.titleMedium!.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFamily: fontFamily);
      case 'titleLarge':
        textStyle = appTheme.textTheme.titleMedium!.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFamily: fontFamily);
      case 'bodyMedium':
        textStyle = appTheme.textTheme.titleMedium!.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFamily: fontFamily);
      case 'bodyLarge':
        textStyle = appTheme.textTheme.titleMedium!.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize ?? 18,
            fontFamily: fontFamily);
      case 'bodySmall':
        textStyle = appTheme.textTheme.titleMedium!.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize ?? 14,
            fontFamily: fontFamily);
      default:
        textStyle = appTheme.textTheme.bodyLarge!.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFamily: fontFamily);
    }
    return Padding(
      padding: padding!,
      child: Text(
        text,
        style: textStyle.copyWith(
          height: lineHeight,
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
    );
  }
}
