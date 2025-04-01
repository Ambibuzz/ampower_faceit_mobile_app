import 'package:flutter/material.dart';

Widget stripStyle({
  required Widget child
}) {
  return Container(
    padding: const EdgeInsets.all(15),
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: Colors.white,//Color(0xFFC7F2D7),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(20)
    ),
    child: child,
  );
}