// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/const/color_constants.dart';

final themeProvider = ChangeNotifierProvider<AppThemes>((ref) => AppThemes());

class AppThemes extends ChangeNotifier {
  String _currentThemeId = defaultThemeId;

  AppTheme get current => _appThemes[_currentThemeId]!;

  void setCurrentThemeId(String themeId) {
    _currentThemeId = themeId;

    notifyListeners();
  }
}

class AppTheme {
  final String id;

  final ThemeData themeData;

  const AppTheme({
    required this.id,
    required this.themeData,
  });
}

const defaultThemeId = 'default';
const secondaryThemeId = 'secondary';

const _primaryTextColor = primaryTextColor;
const _primaryColor = Colors.black;
const scaffoldBack = white;
const scaffoldBackSec = scaffoldBackgroundSecondaryColor;
const _buttonBackground = buttonBackgroundColor;
const _buttonForeground = buttonForegroundColor;

const primaryTextStyle = TextStyle(
    fontFamily: 'ProximaNova', fontWeight: FontWeight.normal, fontSize: 14);

const numberTextStyle = TextStyle(
    fontFamily: 'JoyRide', fontWeight: FontWeight.normal, fontSize: 20);

const headlineTextStyle = TextStyle(
    fontFamily: 'StretchPro', fontWeight: FontWeight.normal, fontSize: 40);

final primaryTextTheme = TextTheme(
  headlineLarge: headlineTextStyle,
  headlineMedium: headlineTextStyle.copyWith(fontSize: 30),
  headlineSmall: headlineTextStyle.copyWith(fontSize: 20),
  titleLarge:
      primaryTextStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
  titleMedium:
      primaryTextStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
  titleSmall:
      primaryTextStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 14),
  bodyLarge: primaryTextStyle.copyWith(fontSize: 16),
  bodyMedium: primaryTextStyle,
  labelMedium: numberTextStyle,
  bodySmall: primaryTextStyle.copyWith(fontSize: 12),
);

final _appThemes = {
  defaultThemeId: AppTheme(
    id: defaultThemeId,
    themeData: ThemeData.dark().copyWith(
      primaryTextTheme: primaryTextTheme,
      primaryColor: _primaryColor,
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: _primaryColor,
        elevation: 1,
        surfaceTintColor: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _primaryColor,
        elevation: 1,
      ),
      scaffoldBackgroundColor: scaffoldBack,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xff030303),
        secondary: Color(0xff3f3f3f),
        onPrimary: Color(0xff00FF66),
        onSecondary: Color(0xff00CE79),
        background: Color(0xfff3f3f3),
        onBackground: Color(0xff030303),
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            _buttonBackground,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            _buttonForeground,
          ),
        ),
      ),
      textTheme: primaryTextTheme,
    ),
  ),
  secondaryThemeId: AppTheme(
    id: secondaryThemeId,
    themeData: ThemeData.dark().copyWith(
      primaryTextTheme: TextTheme(
        titleLarge: primaryTextStyle.copyWith(
            fontWeight: FontWeight.w700, fontSize: 18),
        bodyLarge: primaryTextStyle.copyWith(fontSize: 16),
        bodyMedium: primaryTextStyle,
        bodySmall: primaryTextStyle.copyWith(fontSize: 12),
      ),
      primaryColor: _primaryColor,
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: _primaryColor,
        elevation: 1,
        surfaceTintColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _primaryColor,
        elevation: 1,
      ),
      scaffoldBackgroundColor: scaffoldBackSec,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xffDD5C9C),
        onPrimary: Color(0xffEAAD3A),
        secondary: Color(0xffEAAD3A),
        onSecondary: Color(0x09ccdd5c),
        background: Color(0xff3D3258),
        error: Colors.red,
        onError: Colors.white,
        surface: Colors.white,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            _buttonBackground,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            _buttonForeground,
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: primaryTextStyle.copyWith(color: _primaryTextColor),
        bodyMedium: primaryTextStyle.copyWith(color: _primaryTextColor),
        bodySmall: primaryTextStyle.copyWith(color: _primaryTextColor),
        headlineSmall:
            primaryTextStyle.copyWith(color: Colors.white, fontSize: 18),
        titleSmall: primaryTextStyle.copyWith(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  ),
};
