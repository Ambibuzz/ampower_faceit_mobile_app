import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Corners {
  static const double sm = 5;
  static const BorderRadius smBorder = BorderRadius.all(smRadius);
  static const Radius smRadius = Radius.circular(sm);

  static const double md = 8;
  static const BorderRadius medBorder = BorderRadius.all(medRadius);
  static const Radius medRadius = Radius.circular(md);

  static const double lg = 10;
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);
  static const Radius lgRadius = Radius.circular(lg);

  static const double xl = 15;
  static const BorderRadius xlBorder = BorderRadius.all(xlRadius);
  static const Radius xlRadius = Radius.circular(xl);

  static const double xxl = 20;
  static const BorderRadius xxlBorder = BorderRadius.all(xxlRadius);
  static const Radius xxlRadius = Radius.circular(xxl);

  static const double xxxl = 25;
  static const BorderRadius xxxlBorder = BorderRadius.all(xxxlRadius);
  static const Radius xxxlRadius = Radius.circular(xxxl);
}

class Spacing {
  static const double widgetSpacingSm = 5;
  static const double widgetSpacingMd = 10;
  static const double widgetSpacingLg = 15;
  static const double widgetSpacingXl = 15;
}

class FontSizes {
  /// Provides the ability to nudge the app-wide font scale in either direction
  static double get scale => 1;
  static double get s10 => 10 * scale;
  static double get s11 => 11 * scale;
  static double get s12 => 12 * scale;
  static double get s14 => 14 * scale;
  static double get s16 => 16 * scale;
  static double get s18 => 18 * scale;
  static double get s24 => 24 * scale;
  static double get s48 => 48 * scale;
}

class Elevations {
  static const xsElevation = 1;
  static const smElevation = 3;
  static const mdElevation = 5;
  static const lgElevation = 7;
  static const xlElevation = 9;
}

class Insets {
  static double scale = 1;
  static double offsetScale = 1;
  // Regular paddings
  static double get xs => 4 * scale;
  static double get sm => 8 * scale;
  static double get med => 12 * scale;
  static double get lg => 16 * scale;
  static double get xl => 32 * scale;
  // Offset, used for the edge of the window, or to separate large sections in the app
  static double get offset => 40 * offsetScale;
}

class Thickness {
  static const double xs = 1;
  static const double sm = 2;
  static const double md = 3;
  static const double lg = 4;
  static const double xl = 5;
}

class TextStyles {
  /// Declare a base style for each Family
  static const TextStyle commonStyle =
      TextStyle(fontWeight: FontWeight.w400, height: 1);

  static TextStyle get h1 => commonStyle.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.s48,
      letterSpacing: -1,
      height: 1.17);
  static TextStyle get h2 =>
      h1.copyWith(fontSize: FontSizes.s24, letterSpacing: -.5, height: 1.16);
  static TextStyle get h3 =>
      h1.copyWith(fontSize: FontSizes.s14, letterSpacing: -.05, height: 1.29);
  static TextStyle get title1 => commonStyle.copyWith(
      fontWeight: FontWeight.bold, fontSize: FontSizes.s18);
  static TextStyle get title2 => commonStyle.copyWith(
      fontWeight: FontWeight.w500, fontSize: FontSizes.s16);
  static TextStyle get title3 => title1.copyWith(
      fontWeight: FontWeight.w500, fontSize: FontSizes.s14);
  static TextStyle get body1 => commonStyle.copyWith(
      fontWeight: FontWeight.normal, fontSize: FontSizes.s14, height: 1.71);
  static TextStyle get body2 =>
      body1.copyWith(fontSize: FontSizes.s12, height: 1.5, letterSpacing: .2);
  static TextStyle get body3 => body1.copyWith(
      fontSize: FontSizes.s12, height: 1.5, fontWeight: FontWeight.bold);
  static TextStyle get callout1 => commonStyle.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: FontSizes.s12,
      height: 1.17,
      letterSpacing: .5);
  static TextStyle get callout2 =>
      callout1.copyWith(fontSize: FontSizes.s10, height: 1, letterSpacing: .25);
  static TextStyle get caption => commonStyle.copyWith(
      fontWeight: FontWeight.w500, fontSize: FontSizes.s11, height: 1.36);
}
