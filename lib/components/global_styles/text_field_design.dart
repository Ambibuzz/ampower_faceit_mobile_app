import 'package:flutter/material.dart';

BoxDecoration textFieldDecoration(){
  return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      border: Border.all(width: 1,color: Colors.grey)
  );
}

InputDecoration inputDecoration(String label,bool isMandatory,{Widget? suffixIcon}) {
  return InputDecoration(
      label: Text.rich(
        TextSpan(
          text: label, // The main label text
          children: <InlineSpan>[
            TextSpan(
              text: isMandatory ? '*' : '', // Add an asterisk if mandatory
              style: const TextStyle(color: Colors.red), // Asterisk in red
            ),
          ],
          style: const TextStyle(color: Colors.black54), // Label style
        ),
      ),
      fillColor: Colors.white,
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      suffixIcon: suffixIcon
  );
}