import 'package:app/core/theme/theme.dart';
import 'package:app/features/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDialog extends ConsumerWidget {
  final String label;
  final Function()? onPressed;

  const AppDialog({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xff6F3DD3)),
      ),
      backgroundColor: appTheme.scaffoldBackgroundColor,
      content: SizedBox(
        height: 228,
        width: 335,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Text(
                label,
                style: appTheme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 20),
      actions: [
        AppButton(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          onPressed: onPressed,
          text: 'OK',
        ),
      ],
    );
  }
}
