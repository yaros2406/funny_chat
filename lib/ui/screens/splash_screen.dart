import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final duration = AppNumbers.lottieDuration;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: duration),
    )..forward();

    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    try {
      await widget._auth.signInAnonymously();
      await Future.delayed(Duration(seconds: duration));
      if (mounted) {
        context.go(AppStrings.authScreenPath);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(opacity: AppNumbers.opacity),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AppStrings.lottie,
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final double opacity;

  const BackgroundImage({
    super.key,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(opacity),
          BlendMode.srcATop,
        ),
        child: Image.asset(
         AppStrings.background,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
