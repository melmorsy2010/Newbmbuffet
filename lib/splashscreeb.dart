import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'bottom.dart';
import 'drink screen.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyBottomNavigationBar(),
        ),
      );    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/images/coffee.json',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 10),
          SizedBox(
            width: 300.0,
            child: TextLiquidFill(
              loadDuration: Duration(seconds: 3),
              text: 'Retail Tribe Buffet',
              waveColor: Colors.brown,
              boxBackgroundColor: Colors.white,
              textStyle: GoogleFonts.lato(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              boxHeight: 60.0,
            ),
          ),

              Text(
                "Mohamed Nazmy",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
