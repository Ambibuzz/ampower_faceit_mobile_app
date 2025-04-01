import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MediumDescription extends StatelessWidget {
  const MediumDescription(
      {super.key, required this.title, required this.headingColor});
  final String title;
  final Color headingColor;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
          textStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: headingColor)),
    );
  }
}
