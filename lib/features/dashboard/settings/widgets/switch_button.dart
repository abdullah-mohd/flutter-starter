import 'package:layout/layout.dart';
import 'package:app/core/theme/app_text.dart';
import 'package:app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwitchButton extends ConsumerWidget {
  final bool selected;
  final String text;
  final Function() onTap;
  final bool isFirst;
  final List<Color> gradientColors;
  const SwitchButton({
    super.key,
    required this.selected,
    required this.text,
    required this.onTap,
    this.isFirst = true,
    this.gradientColors = const [
      Colors.grey,
      Colors.black,
    ],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        height: 27,
        width: context.layout.width * 0.2,
        decoration: BoxDecoration(
          color: !selected ? appTheme.colorScheme.background : null,
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                )
              : null,
          borderRadius: isFirst
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          border: Border.fromBorderSide(
            BorderSide(
              color: appTheme.colorScheme.onPrimary,
              width: 0.5,
            ),
          ),
        ),
        child: AppText(
          text,
          fontSize: 12,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
