import 'package:app/core/theme/theme.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackdropScaffold extends ConsumerWidget {
  final Widget child;

  const BackdropScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeProvider = ref.watch(themeProvider);
    final appTheme = appThemeProvider.current.themeData;
    return Scaffold(
      backgroundColor: appTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          ...backdropWidgets(context, appTheme),
          child,
        ],
      ),
    );
  }
}
