import 'package:flutter/material.dart';

class UndefinedView extends StatelessWidget {
  final String? name;
  const UndefinedView({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}
