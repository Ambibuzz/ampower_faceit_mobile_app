import 'package:flutter/material.dart';

Widget buildLabel(Map fieldInfo) {
  bool isRequired = fieldInfo['reqd'] == 1;
  return RichText(
    text: TextSpan(
      text: fieldInfo['label'] ?? '',
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      children: isRequired
          ? const [
        TextSpan(
          text: ' *',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]
          : [],
    ),
  );
}
