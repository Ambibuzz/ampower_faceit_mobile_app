import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';

fluttertoast(BuildContext context, String message) {
  return showToast(message,
      context: context,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToTop,
      position: StyledToastPosition.top,
      startOffset: const Offset(0.0, -3.0),
      reverseEndOffset: const Offset(0.0, -3.0),
      duration: const Duration(seconds: 3),
      animDuration: const Duration(seconds: 1),
      curve: Curves.elasticOut,
      reverseCurve: Curves.fastOutSlowIn);
}
