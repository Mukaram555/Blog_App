import 'package:bolg_app/colors/colors.dart';
import 'package:bolg_app/const/round_button.dart';
import 'package:bolg_app/const/validation_methods.dart';
import 'package:bolg_app/screens/forget_password.dart';
import 'package:bolg_app/screens/home_page.dart';
import 'package:bolg_app/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '', password = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: signInScreenBackgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: backArrowColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Center(
                  child: Text(
                    "Log In",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: headingColorText,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                            hintText: "Please Enter Your Email",
                            labelText: "Email",
                            labelStyle: const TextStyle(color: Colors.white),
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white70,
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            errorStyle: TextStyle(color: textColor),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.white70),
                            )),
                        onChanged: (String value) {
                          email = value;
                          validateEmail(value.toString());
                        },
                        validator: (value) {
                          if (value == null) {
                            setState(() {
                              showSpinner = false;
                            });
                            return 'Email is Required';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            setState(() {
                              showSpinner = false;
                            });
                            return 'Invalid Email';
                          }
                          setState(() {
                            showSpinner = false;
                          });
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(color: Colors.white54),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.white70,
                          ),
                          suffixIcon: const Icon(Icons.remove_red_eye),
                          suffixIconColor: Colors.white70,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          errorStyle: TextStyle(color: textColor),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.white70),
                          ),
                        ),
                        onChanged: (String value) {
                          password = value;
                          validatePassword(value.toString());
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is Required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      RoundButton(
                          title: "Log In",
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              try {
                                final result =
                                    await _auth.signInWithEmailAndPassword(
                                  email: email.toString().trim(),
                                  password: password.toString().trim(),
                                );
                                if (result != null) {
                                  toastMessage("User LogIn Successfully");
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    showSpinner = false;
                                    toastMessage(
                                        "Email or Password is incorrect");
                                  });
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  toastMessage('No user found for that email.');
                                } else if (e.code == 'wrong-password') {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  toastMessage(
                                      'Wrong password provided for that user.');
                                }
                              }
                            }
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgetPassword(),),);
                        },
                        child: Text(
                          "Forget Password",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create an account/ ",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                            )
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignIn(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.playfairDisplay(
                                color: textColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: roundButtonBorderColor,
        textColor: textColor,
        fontSize: 16.0);
  }
}

