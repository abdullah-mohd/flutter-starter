import 'package:app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppProgressBar extends ConsumerWidget {
  final double value;
  const AppProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            appTheme.colorScheme.primary,
            appTheme.colorScheme.secondary,
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: value,
          color: const Color(0xff1B24FF),
          minHeight: 6,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
