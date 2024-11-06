import 'package:app/core/theme/theme.dart';
import 'package:app/features/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmationDialog extends ConsumerWidget {
  final String label;
  final Function()? onPressed;

  const ConfirmationDialog({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xff6F3DD3)),
      ),
      backgroundColor: appTheme.scaffoldBackgroundColor,
      child: SizedBox(
        height: 317,
        width: 335,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Text(
                label,
                style: appTheme.textTheme.displayMedium!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: const Text('OTP'),
                  ),
                ),
              ),
            ),
            AppButton(
              onPressed: onPressed,
              text: 'OK',
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ],
        ),
      ),
    );
  }
}
