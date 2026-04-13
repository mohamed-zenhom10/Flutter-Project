import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:main/screens/on_boarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset("assets/app_icon.png" , width: size.width * 0.5,).animate(
        onComplete: (v) => {
          Navigator.push(context , CupertinoPageRoute(builder: (context) => OnBoarding())),
        }
      ).fadeIn(
        duration: Duration(milliseconds: 500),
      ).fadeOut(
        delay: Duration(seconds: 2),
        duration: Duration(milliseconds: 500),
      ),
      )
    );
  }
}
