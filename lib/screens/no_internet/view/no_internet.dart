import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import '../../../components/black_button/black_button.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  bool _isChecking = false;

  Future<void> _retryConnection() async {
    setState(() {
      _isChecking = true;
    });

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Internet is back, pop this page
        Navigator.of(context).pop(true);
      } else {
        _showNoInternetSnack();
      }
    } on SocketException catch (_) {
      _showNoInternetSnack();
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  void _showNoInternetSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Still no internet connection. Please try again.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              "assets/images/no_internet.png", // New No Internet Icon
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50),
            const Text(
              'No Internet Connection. Please check your Wifi or Mobile Data and try again.',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: raisedBlackButtonStyle,
              onPressed: _isChecking ? null : _retryConnection,
              child: Text(
                _isChecking ? 'Checking...' : 'Retry',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
