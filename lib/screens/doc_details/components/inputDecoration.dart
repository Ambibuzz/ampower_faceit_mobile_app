import 'package:flutter/material.dart';

InputDecoration inputDecoration(label) {
  return InputDecoration(
    //label: Text(label),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
          color: Colors.black, width: 1.0), // Default border color
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
          color: Colors.black, width: 1.0), // Unfocused border
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
      const BorderSide(color: Colors.blue, width: 2), // Focused border
    ),
  );
}