import 'package:bolg_app/colors/colors.dart';
import 'package:bolg_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'option_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      final user = _auth.currentUser;
      if(user != null){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OptionScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splashScreenBackgroundColor,
      body: const Center(child: Image(image: AssetImage('assets/splashlogo.png'),)),
    );
  }
}