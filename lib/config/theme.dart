
import 'package:community/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTheme {
  static TextTheme textTheme = TextTheme(
      displayLarge: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5)),
      displayMedium: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5)),
      displaySmall: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 48, fontWeight: FontWeight.w400, letterSpacing: 0.0)),
      headlineMedium: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25)),
      headlineSmall: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0.0)),
      titleLarge: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15)),
      titleMedium: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15)),
      titleSmall: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.15)),
      bodyLarge: GoogleFonts.dmSans(
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5)),
      bodyMedium:
          GoogleFonts.dmSans(textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25)),
      labelLarge: GoogleFonts.dmSans(textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25)),
      bodySmall: GoogleFonts.dmSans(textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4)),
      labelSmall: GoogleFonts.dmSans(textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5)));

  static TextStyle appBarTitleTextStyle = GoogleFonts.dmSans(
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15));

  static TextStyle dialogTitleTextStyle = GoogleFonts.dmSans(
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15));

  static TextStyle dialogContentTextStyle = GoogleFonts.dmSans(
      textStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4));

  static TextStyle buttonTextStyle = GoogleFonts.dmSans(
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.15));

  static const buttonShape =
      RoundedRectangleBorder(borderRadius: Corners.xxlBorder);

  static const buttonShapeWithBorder = RoundedRectangleBorder(
    borderRadius: Corners.xlBorder,
    side: BorderSide(color: Colors.white, width: 1),
  );

  static const buttonBorder = Corners.xlBorder;

  static const double elevation = 3;

  static const double dividerThickness = 1;

  static double iconSize = FontSizes.s24;

  static Color fillColorGrey = const Color(0xFFF3F3F3);
  static var greyColor = const Color(0xFFE7E5E5);

  // static final Color primarycolor = Palette.primaryColor;
  static const primarycolor = Color(0xFF11365B);//Colors.black;

  //Light Theme
  // static Color backgroundColorLight = Palette.backgroundColor;
  // static Color backgroundColorLight = Colors.white;
  static Color backgroundColorLight = const Color(0xFFFAFAFA);

  // static Color backgroundColorLight = Palette.bgColor;
  static Brightness brightnessLight = Brightness.light;
  static Color disabledColorLight = greyColor;
  static Color errorColorLight = const Color(0xFFB00020);
  static Color appBarIconThemeColorLight = const Color(0xFFFFFFFF);
  static Color onBackgroundColorLight = const Color(0xFF000000);
  static Color onErrorColorLight = const Color(0xFFFFFFFF);
  static Color onPrimaryColorLight = const Color(0xFFFFFFFF);
  static Color onSecondaryColorLight = const Color(0xFFFFFFFF);
  static Color onSurfaceColorLight = const Color(0xFF000000);
  static Color primaryColorLight = primarycolor;

  // static Color primaryColorLight =Color(0xFF53B175);
  // static Color primaryColorLight = Color(0xFF6200EE);
  static Color primaryVariantLight = const Color(0xFF3700B3);
  static Color secondaryColorLight = const Color(0xFF03DAC6);
  static Color secondaryVariantLight = const Color(0xFF018786);
  static Color surfaceColorLight = const Color(0xFFFFFFFF);

  //Chart Color Data
  static Color chartColorTarget = primaryColorLight;
  static Color chartColorAchievement = secondaryColorLight;
  static Color chartColorPrediction = Colors.green;
  static Color tableHeaderColor = const Color(0xFFD6D6D6);

  static var dropdownColor = const Color(0xFFD9D9D9);
  static var toastMessageBgColor = const Color(0xFFB0D1E8);
  static var iconColor = const Color(0xFF666666);

  static ThemeData lightTheme({Color? primaryColor}) {
    return ThemeData(
      textTheme: textTheme,
      scaffoldBackgroundColor: backgroundColorLight,
      disabledColor: disabledColorLight,
      primaryColor: primaryColor ?? primaryColorLight,
      brightness: brightnessLight,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColorLight,
        titleTextStyle: appBarTitleTextStyle,
        actionsIconTheme:
            IconThemeData(color: appBarIconThemeColorLight, size: iconSize),
        iconTheme:
            IconThemeData(color: appBarIconThemeColorLight, size: iconSize),
        elevation: elevation,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor ?? primaryColorLight,
        disabledColor: disabledColorLight,
        textTheme: ButtonTextTheme.primary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        surfaceTintColor: surfaceColorLight,
        backgroundColor: surfaceColorLight,
      ),
      cardTheme: CardTheme(
          color: surfaceColorLight,
          elevation: elevation,
          surfaceTintColor: surfaceColorLight),
      checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(onBackgroundColorLight),
          fillColor: MaterialStateProperty.all(backgroundColorLight),
          side: BorderSide(color: onBackgroundColorLight, width: 1)),
      dataTableTheme: DataTableThemeData(
        decoration: BoxDecoration(
            color: surfaceColorLight, borderRadius: Corners.medBorder),
      ),
      dialogTheme: DialogTheme(
          backgroundColor: backgroundColorLight,
          titleTextStyle:
              dialogTitleTextStyle.copyWith(color: onSurfaceColorLight),
          contentTextStyle:
              dialogContentTextStyle.copyWith(color: onSurfaceColorLight),
          elevation: elevation),
      dialogBackgroundColor: backgroundColorLight,
      dividerColor: greyColor,
      dividerTheme: DividerThemeData(
        color: greyColor,
        thickness: dividerThickness,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(primaryColor ?? primaryColorLight),
          elevation: MaterialStateProperty.all(elevation),

          textStyle: MaterialStateProperty.all(buttonTextStyle),
          shape: MaterialStateProperty.all(buttonShape),
          foregroundColor: MaterialStateProperty.all(onPrimaryColorLight),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor ?? primaryColorLight,
        foregroundColor: onSecondaryColorLight,
        disabledElevation: elevation,
        elevation: elevation,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: surfaceColorLight,
        textColor: Colors.black,
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        collapsedBackgroundColor: surfaceColorLight,
        collapsedTextColor: Colors.black,
        // shape: const RoundedRectangleBorder(borderRadius: Corners.xlBorder),
      ),
      iconTheme: IconThemeData(color: onBackgroundColorLight, size: iconSize),
      inputDecorationTheme: InputDecorationTheme(
        // fillColor: surfaceColorLight,
        fillColor: fillColorGrey,
        filled: true,
        isDense: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: Corners.xlBorder,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorColorLight,
          ),
          borderRadius: Corners.xlBorder,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor ?? primaryColorLight,
          ),
          borderRadius: Corners.xlBorder,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorColorLight,
          ),
          borderRadius: Corners.xlBorder,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(primaryColor ?? primaryColorLight),
          elevation: MaterialStateProperty.all(elevation),
          textStyle: MaterialStateProperty.all(buttonTextStyle),

          shape: MaterialStateProperty.all(buttonShapeWithBorder),
          foregroundColor: MaterialStateProperty.all(onPrimaryColorLight),
        ),
      ),
      primaryIconTheme: IconThemeData(
          color: primaryColor ?? primaryColorLight, size: iconSize),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: onBackgroundColorLight,
        actionTextColor: backgroundColorLight,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(primaryColor ?? primarycolor),
          elevation: MaterialStateProperty.all(elevation),
          textStyle: MaterialStateProperty.all(buttonTextStyle),
          shape: MaterialStateProperty.all(buttonShape),
          foregroundColor: MaterialStateProperty.all(onPrimaryColorLight),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme(
              primary: primaryColor ?? primaryColorLight,
              secondary: secondaryColorLight,
              surface: surfaceColorLight,
              background: backgroundColorLight,
              error: errorColorLight,
              onPrimary: onPrimaryColorLight,
              onSecondary: onSecondaryColorLight,
              onSurface: onBackgroundColorLight,
              onBackground: onBackgroundColorLight,
              onError: onErrorColorLight,
              brightness: brightnessLight)
          .copyWith(background: backgroundColorLight)
          .copyWith(error: errorColorLight),
    );
  }
}
