import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../colors/colors.dart';
import '../const/round_button.dart';
import '../const/validation_methods.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String email = '';
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
                    "Forget Password",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: headingColorText,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      RoundButton(
                          title: "Recover Password",
                          sizeOfText: 20,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              try {
                                _auth.sendPasswordResetEmail(email: emailController.text.toString(),
                                ).then((value) {
                                  toastMessage("Please Check Your Email Reset Link send to Your email");
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  toastMessage(error.toString());
                                });
                              }catch (e) {
                                setState(() {
                                  showSpinner = false;
                                });
                                toastMessage(e.toString());
                              }
                            }
                          }),
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
