import 'package:community/locator/locator.dart';
import 'package:community/router/routing_constants.dart';
import 'package:community/service/navigation_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _height = 0;
  bool _heightAnimationComplete = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isCircle = false;
  bool _showLogo = false;
  bool _fillFullScreen = false;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // animation controller initialization
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _startAnimations();
    });
    // rotation animation controller initialization
    _rotationAnimation =
    Tween<double>(begin: 0, end: 2 * 3.14159).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ))
      ..addStatusListener((status) {
        // Step 3: Rotate the square in anticlockwise direction transform to a circle when forward animation is completed
        if (status == AnimationStatus.completed) {
          setState(() {
            _isCircle = true;
          });
          _controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimations() async {
    // Step 1: increase height of square from 0 to 100
    setState(() {
      _height = 100;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _heightAnimationComplete = true;
      });
      // Step 2: Rotate the square in clockwise direction
      _controller.forward();
    });
    // Step 4: Create fading effect and show AmPower logo
    await Future.delayed(const Duration(milliseconds: 2400), () {
      setState(() {
        _showLogo = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    // Step 5: Fill entire screen with background color from circle
    await Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _fillFullScreen = true;
      });
    });
    await Future.delayed(const Duration(seconds: 1),() {
      locator.get<NavigationService>().navigateTo(homeScreenViewRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: _startAnimations,
              child: _heightAnimationComplete
                  ? AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: AnimatedContainer(
                      duration: Duration(
                          milliseconds: _fillFullScreen ? 500 : 1000),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [
                              Color(0xFF006CB5),
                              Color(0xFF002D4C)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        // shape:
                        //     _isCircle ? BoxShape.circle : BoxShape.rectangle,
                        borderRadius:
                        BorderRadius.circular(_fillFullScreen
                            ? 0
                            : _isCircle
                            ? 50
                            : 15),
                      ),
                      width: _fillFullScreen
                          ? MediaQuery.of(context).size.width
                          : _isCircle
                          ? 0
                          : 100,
                      height: _fillFullScreen
                          ? MediaQuery.of(context).size.height
                          : _isCircle
                          ? 0
                          : 100,
                      curve: Curves.easeInOut,
                    ),
                  );
                },
              )
                  : AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: 100,
                height: _height,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF006CB5), Color(0xFF002D4C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(15)),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          _showLogo
              ? Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              opacity: _opacity,
              child: Container(
                width: 230,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/ambibuzz_icon.png',
                ),
              ),
            ),
          )
              : const SizedBox(),
        ],
      ),
    );
  }
}