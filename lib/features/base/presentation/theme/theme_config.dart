import 'package:flutter/material.dart';

const Color bayaInfraWhiteColor = Color(0xFFFFFFFF);
const Color bayaInfraBlackColor = Color(0xFF0F1B2D); // Ink-style premium color
const Color bayaInfraRedColor   = Colors.red;
const Color bayaInfraGreyColor = Colors.grey;
final bayaInfraGreen = const Color(0xFF00C853);
final bayaInfraGraphBluePrimary = const Color(0xFF1678CF);
Color? bayaInfraGrey = Colors.grey;
final bayaInfraPaleGreen = const Color(0xFF66BB6A);
final bayaInfraBlue600 = Colors.blue[600];
const Color bayaInfraBlue100 = Color(0xFFBBDEFB);
final bayaInfraBlue50 = Colors.blue[50];
final bayaInfraPaleOrange = const Color(0xFFEF5350);
final bayaInfraPaleOrangeRed = const Color(0xFFF44336);
const Color bayaInfraPaleLightGreen  = Color(0xFF10b981);
const Color bayaInfraLightGreenColor = Color(0xFFA8D5BA);

const Color bayaInfraDisabledColor     = Color(0xFFAFAFAF);
const Color bayaInfraTextColorDark = Color(0xFF5F6368);

final Color kDefaultIconLightColor = const Color(0xFFFFFFFF);
final Color kDefaultIconDarkColor  = const Color(0xDD000000);

final bayaInfraRed           = const Color(0xFFE57368);
final bayaInfraAmber         = Colors.amber;
final bayaInfraYellow        = const Color(0xFFFFA726);
final bayaInfraPaleYellow    = const Color(0xFFFFCC80);
final bayaInfraLightRedColor = const Color(0xFFF28B82);

final bayaInfraGrey300 = Colors.grey[300];
final bayaInfraGrey400 = Colors.grey[400];
Color? bayaInfraGrey600  = Colors.grey[600];
Color? bayaInfraGrey100  = Colors.grey[100];
Color? bayaInfraBlack12  = Colors.black12;

class _Palette {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;

  final Color navSelectedLight;
  final Color navUnselectedLight;

  final Color scaffoldLight;
  final Color cardLight;
  final Color lightCardLight;
  final Color canvasLight;
  final Color lightHint;

  final Color subContainerLight;

  final Color lightGreen;
  final Color paleGreen;
  final Color green;
  final Color paleOrangeRed;
  final Color paleOrange;

  final Color blueDark;
  final Color blue100;
  final Color blue50;

  final Color? lightBlue200op9;
  final Color? lightBlue100op7;
  final Color? lightBlue100op8;

  const _Palette({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.navSelectedLight,
    required this.navUnselectedLight,
    required this.scaffoldLight,
    required this.cardLight,
    required this.lightCardLight,
    required this.canvasLight,
    required this.lightHint,
    required this.subContainerLight,
    required this.lightGreen,
    required this.paleGreen,
    required this.green,
    required this.paleOrangeRed,
    required this.paleOrange,
    required this.blueDark,
    required this.blue100,
    required this.blue50,
    required this.lightBlue200op9,
    required this.lightBlue100op7,
    required this.lightBlue100op8,
  });
}

final _Palette _skyBlue = _Palette(
  primary:            const Color(0xFF0298DB),
  primaryDark:        const Color(0xFF0172A3),
  primaryLight:       const Color(0xFF4DB8F0),
  navSelectedLight:   const Color(0xFF0298DB),
  navUnselectedLight: const Color(0xFF5A8A9F),
  scaffoldLight:      const Color(0xFFFCFEFF),
  cardLight:          const Color(0xFFFFFFFF),
  lightCardLight:     const Color(0xFFEAF4FB),
  canvasLight:        const Color(0xFFF2F7FB),
  lightHint:          const Color(0xFFF6FAFD),
  subContainerLight:  const Color(0xFFB3DCF0),
  lightGreen:         const Color(0xFFB3E5D0),
  paleGreen:          const Color(0xFF5AADA0),
  green:              const Color(0xFF2E9E8A),
  paleOrangeRed:      const Color(0xFFC4613E),
  paleOrange:         const Color(0xFFD4724A),
  blueDark:           const Color(0xFF0298DB),
  blue100:            const Color(0xFFCCEBF8),
  blue50:             const Color(0xFFE6F5FC),
  lightBlue200op9:    const Color(0xFFB3DCF0).withOpacity(0.9),
  lightBlue100op7:    const Color(0xFFD6EEF8).withOpacity(0.7),
  lightBlue100op8:    const Color(0xFFD6EEF8).withOpacity(0.8),
);

final _Palette _forestGreen = _Palette(
  primary:            const Color(0xFF4A8C55),
  primaryDark:        const Color(0xFF2E6638),
  primaryLight:       const Color(0xFF7BBF87),
  navSelectedLight:   const Color(0xFF4A8C55),
  navUnselectedLight: const Color(0xFF6A8470),
  scaffoldLight:      const Color(0xFFFCFDFB),
  cardLight:          const Color(0xFFFFFFFF),
  lightCardLight:     const Color(0xFFF2F6EF),
  canvasLight:        const Color(0xFFF5F8F2),
  lightHint:          const Color(0xFFF8FAF6),
  subContainerLight:  const Color(0xFFC4D9C6),
  lightGreen:         const Color(0xFFC0DDB7),
  paleGreen:          const Color(0xFF5A9E68),
  green:              const Color(0xFF3D9142),
  paleOrangeRed:      const Color(0xFFC4613E),
  paleOrange:         const Color(0xFFD4724A),
  blueDark:           const Color(0xFF506A8A),
  blue100:            const Color(0xFFDCE8F4),
  blue50:             const Color(0xFFEEF4FA),
  lightBlue200op9:    const Color(0xFFC4D9C6).withOpacity(0.9),
  lightBlue100op7:    const Color(0xFFDCE8F4).withOpacity(0.7),
  lightBlue100op8:    const Color(0xFFDCE8F4).withOpacity(0.8),
);

ThemeData _buildLight(_Palette p) => ThemeData.light().copyWith(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: bayaInfraBlackColor,
    selectionColor: p.primary.withOpacity(0.3),
    selectionHandleColor: p.primary,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: p.primary,
    primary: bayaInfraBlackColor,
    secondary: bayaInfraWhiteColor,
    tertiary: p.subContainerLight,
    onTertiary: bayaInfraGrey100,
    inversePrimary: p.lightBlue200op9,
    onInverseSurface: p.lightBlue100op7,
    inverseSurface: p.lightBlue100op8,
  ),
  hintColor: p.lightHint,
  dialogTheme: DialogThemeData(backgroundColor: p.scaffoldLight),
  cardColor: p.cardLight,
  scaffoldBackgroundColor: p.scaffoldLight,
  highlightColor: p.lightCardLight,
  primaryColor: p.primary,
  primaryColorDark: bayaInfraBlackColor,
  secondaryHeaderColor: p.primary,
  primaryColorLight: p.navSelectedLight,
  tabBarTheme: const TabBarThemeData(indicatorColor: Colors.black54),
  canvasColor: p.canvasLight,
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) return p.primary;
      return bayaInfraWhiteColor;
    }),
    checkColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) return bayaInfraWhiteColor;
      return null;
    }),
    side: WidgetStateBorderSide.resolveWith(
          (states) => const BorderSide(color: bayaInfraBlackColor, width: 2.0),
    ),
  ),
  iconTheme: IconThemeData(color: kDefaultIconDarkColor),
  disabledColor: bayaInfraDisabledColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: bayaInfraWhiteColor,
    type: BottomNavigationBarType.fixed,
    selectedIconTheme: IconThemeData(color: p.navSelectedLight, size: 24),
    selectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    unselectedIconTheme: const IconThemeData(color: bayaInfraTextColorDark, size: 24),
    unselectedLabelStyle: const TextStyle(fontSize: 12),
    selectedItemColor: p.navSelectedLight,
    unselectedItemColor: p.navUnselectedLight,
  ),
  shadowColor: p.primary,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: p.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: p.primary,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: p.primary,
      side: BorderSide(color: p.primary),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge:   TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w700, fontSize: 28),
    displayMedium:  TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w700, fontSize: 26),
    displaySmall:   TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w600, fontSize: 24),
    headlineLarge:  TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w700, fontSize: 22),
    headlineMedium: TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w700, fontSize: 19),
    headlineSmall:  TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w600, fontSize: 19),
    titleLarge:     TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w700, fontSize: 16),
    titleMedium:    TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w600, fontSize: 14),
    titleSmall:     TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w600, fontSize: 13),
    labelLarge:     TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w700, fontSize: 12),
    labelMedium:    TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w500, fontSize: 11),
    labelSmall:     TextStyle(color: bayaInfraTextColorDark, fontWeight: FontWeight.w500, fontSize: 10),
    bodyLarge:      TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w500, fontSize: 14),
    bodyMedium:     TextStyle(color: bayaInfraTextColorDark, fontWeight: FontWeight.w500, fontSize: 13),
    bodySmall:      TextStyle(color: bayaInfraTextColorDark, fontWeight: FontWeight.w400, fontSize: 12),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: bayaInfraBlackColor),
    titleTextStyle: TextStyle(color: bayaInfraBlackColor, fontWeight: FontWeight.w700, fontSize: 18),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderSide: const BorderSide(color: bayaInfraDisabledColor), borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: bayaInfraDisabledColor), borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: p.primary, width: 2.0), borderRadius: BorderRadius.circular(10)),
    errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
    focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2.0), borderRadius: BorderRadius.circular(10)),
  ),
);

enum AppThemeVariant {
  skyBlue,
  forestGreen,
}

class AppThemes {
  AppThemes._();

  static final ThemeData skyBlueTheme     = _buildLight(_skyBlue);
  static final ThemeData forestGreenTheme = _buildLight(_forestGreen);

  static ThemeData light(AppThemeVariant v) {
    switch (v) {
      case AppThemeVariant.skyBlue:     return skyBlueTheme;
      case AppThemeVariant.forestGreen: return forestGreenTheme;
    }
  }
}
