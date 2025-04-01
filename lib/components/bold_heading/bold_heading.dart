import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Boldheading extends StatelessWidget {
  const Boldheading(
      {super.key, required this.title, required this.headingColor})
      ;
  final String title;
  final Color headingColor;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
          textStyle: TextStyle(
              fontSize: 36, fontWeight: FontWeight.w500, color: headingColor)),
    );
  }
}
