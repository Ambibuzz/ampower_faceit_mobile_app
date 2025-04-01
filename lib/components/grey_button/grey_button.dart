///Import Dart Modules
import 'package:flutter/material.dart';

import '../../helpers/colors.dart';

final ButtonStyle raisedGreyButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white, backgroundColor: themeGrey,
  minimumSize: const Size(370, 48),
  // padding: const EdgeInsets.symmetric(horizontal: 10),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
