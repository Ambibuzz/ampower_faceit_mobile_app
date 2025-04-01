///Import Dart Modules
import 'package:flutter/material.dart';

import '../../helpers/colors.dart';

final ButtonStyle raisedBlueButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white, backgroundColor: themeBlue,
  minimumSize: const Size(370, 58),
  // padding: const EdgeInsets.symmetric(horizontal: 10),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
);
