import 'package:flutter/material.dart';

ThemeData createAppTheme(BuildContext context, {brightness = Brightness.light}) {
  final ColorScheme colorScheme = ColorScheme.fromSwatch().copyWith(
    brightness: brightness,
    primary: Color(0xFFE91E63),
    onPrimary: Color(0xFFE91E63),
    secondary: Color(0xFF3F51B5),
    onSecondary: Color(0xFF3F51B5),
    error: Color(0xFFF44336),
    onError: Color(0xFFF44336),
    surface: Color(0xFFFFC107),
    onSurface: Color(0xFF212121),
  );

  return ThemeData(
    brightness: brightness,
    appBarTheme: AppBarTheme(color: Colors.transparent),
    primaryColor: Color(0xFFFFFFFF),
    colorScheme: colorScheme,
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    dividerColor: Colors.transparent,
    dialogTheme: DialogTheme(backgroundColor: Color(0xFFF1F8E9)),
    disabledColor: Color(0xFFB3E5FC),
    badgeTheme: BadgeThemeData(backgroundColor: Colors.amber),
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: Color(0xFFE91E63),
        onPrimary: Color(0xFFE91E63),
        secondary: Color(0xFF3F51B5),
        onSecondary: Color(0xFF3F51B5),
        error: Color(0xFFF44336),
        onError: Color(0xFFF44336),
        surface: Color(0xFFFFC107),
        onSurface: Color(0xFF212121),
      ),
    ),
    cardColor: Color(0xFFF5F5F5),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) return Color(0xFF9E9E9E);
          return Color(0xFF4CAF50);
        }),
        textStyle: WidgetStateProperty.all(TextStyle(fontFamily: 'Montserrat', fontSize: 17, fontWeight: FontWeight.w600)),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 62)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Color(0xFF4CAF50)),
        textStyle: WidgetStateProperty.all(TextStyle(fontFamily: 'Montserrat', fontSize: 17, fontWeight: FontWeight.w600)),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 62)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
      ),
    ),
    fontFamily: 'NotoSans',
    textTheme: TextTheme(
      headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(fontSize: 14, fontFamily: 'NotoSans', fontWeight: FontWeight.w400),
      fillColor: Color(0xFF9E9E9E),
    ),
    unselectedWidgetColor: Color(0xFF4CAF50),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary.withValues(alpha: 0.5);
        }
        return null;
      }),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {TargetPlatform.android: ZoomPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder()},
    ),
  );
}
