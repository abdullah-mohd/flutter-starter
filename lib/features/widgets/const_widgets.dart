import 'package:app/core/const/constants.dart';
import 'package:app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

Center appLogo(
  BuildContext context, {
  bool alt = false,
  double height = 65,
  BoxFit fit = BoxFit.fitHeight,
}) =>
    Center(
      child: SizedBox(
        height: height,
        child: Image.asset(
          appLogoURL,
          fit: fit,
        ),
      ),
    );

SizedBox sized({double? w, double? h, Widget? c}) => SizedBox(
      width: w,
      height: h,
      child: c,
    );

List<Widget> backdropWidgets(
  BuildContext context,
  ThemeData appTheme,
) =>
    [
      Align(
        alignment: Alignment.center,
        child: Image.asset(
          appLogoURL,
          height: 640,
          width: context.layout.maxWidth * 0.6,
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 20),
          width: context.layout.maxWidth * 0.6,
          height: context.layout.height,
          color: appTheme.scaffoldBackgroundColor.withAlpha(200),
        ),
      ),
    ];

class AppLoader extends ConsumerWidget {
  final double? value;
  const AppLoader({super.key, this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [.5, 1],
        colors: [
          appTheme.colorScheme.primary,
          appTheme.colorScheme.secondary,
        ],
      ).createShader(bounds),
      child: CircularProgressIndicator(
        // color: appTheme.colorScheme.primary,
        valueColor: AlwaysStoppedAnimation<Color>(
          appTheme.colorScheme.secondary,
        ),
        backgroundColor: Colors.transparent,
        value: value,
      ),
    );
  }
}

class LinearAppLoader extends ConsumerWidget {
  final double? value;
  const LinearAppLoader({super.key, this.value});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider).current.themeData;
    return Container(
      alignment: Alignment.center,
      height: 4,
      width: 40,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) => LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [.5, 1],
          colors: [
            appTheme.colorScheme.primary,
            appTheme.colorScheme.secondary,
          ],
        ).createShader(bounds),
        child: CircularProgressIndicator(
          // color: appTheme.colorScheme.primary,
          valueColor: AlwaysStoppedAnimation<Color>(
            appTheme.colorScheme.secondary,
          ),
          backgroundColor: Colors.transparent,
          value: value,
        ),
      ),
    );
  }
}
