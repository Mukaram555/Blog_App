import 'package:bolg_app/colors/colors.dart';
import 'package:bolg_app/screens/sign_up.dart';
import 'package:flutter/material.dart';
import '../const/round_button.dart';
import 'login_page.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: optionScreenBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/splashlogo.png'),
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              RoundButton(title: "Log In", onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage(),),);
              }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              RoundButton(title: "Sign Up", onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignIn(),),);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
