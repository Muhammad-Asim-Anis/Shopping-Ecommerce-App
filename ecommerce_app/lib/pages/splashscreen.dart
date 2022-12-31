import 'package:ecommerce_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});

  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splashIconSize: 200,
        duration: 4000,
        splash: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 70,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(0),
                child: const Icon(
                  CupertinoIcons.cart,
                  color: Colors.white,
                  size: 108,
                ),
              ),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2),
                    overflow: TextOverflow.clip,
              )
            ],
          ),
        ),
        nextScreen: const HomePage(email: "", name: "", userid: 0, usercontact: "", status: false),
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(255, 0, 157, 207));
  }
}
