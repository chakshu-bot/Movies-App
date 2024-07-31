import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3600), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomNavBar(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.grey,
          child: Align(
              alignment: Alignment.center,
              child: Lottie.asset('assets/splash.json'))),
    );
  }
}
