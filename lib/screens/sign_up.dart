import 'package:bolg_app/colors/colors.dart';
import 'package:bolg_app/const/round_button.dart';
import 'package:bolg_app/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const/validation_methods.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '', password = '', cPassword = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                    "Sign Up",
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
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                            hintText: "Please Enter Your Email",
                            labelText: "Email",
                            labelStyle:const TextStyle(color: Colors.white),
                            hintStyle:const TextStyle(color: Colors.white54),
                            prefixIcon:const Icon(
                              Icons.email,
                              color: Colors.white70,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:const BorderSide(color: Colors.blue),
                            ),
                            errorStyle: TextStyle(color: textColor),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:const BorderSide(color: Colors.red),
                            ),

                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:const BorderSide(color: Colors.white70),
                            )),
                        onChanged: (String value) {
                          email = value;
                        },
                        validator: (value) {
                          if(email.contains("@")){
                            return null;
                          }else{
                            return "Please enter the Correct Email Address";
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextStyle(color: textColor, fontSize: 18),
                        decoration: InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.white),
                            hintStyle:const TextStyle(color: Colors.white54),
                            prefixIcon:const Icon(
                              Icons.password,
                              color: Colors.white70,
                            ),
                            suffixIcon: const Icon(Icons.remove_red_eye),
                            suffixIconColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:const BorderSide(color: Colors.blue),
                            ),
                            errorStyle: TextStyle(color: textColor),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:const BorderSide(color: Colors.red),
                            ),

                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:const BorderSide(color: Colors.white70),
                            )),
                        onChanged: (String value) {
                          password = value;
                          validateEmail(value.toString());
                        },
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please Enter Your Password";
                          }
                          else{
                            if(password.length<6){
                              return "Password must be at least 6 character";
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style: TextStyle(color: textColor, fontSize: 18),
                        decoration: InputDecoration(
                            hintText: "confirm Password",
                            labelText: "Confirm Password",
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

                            errorStyle: TextStyle(color: textColor),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.red),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white70),
                            ),),
                        onChanged: (String value) {
                          cPassword = value;
                          validatePassword(value.toString());
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Confirm Password";
                          } else if (value != password) {
                            return "Password Does Not Match";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      RoundButton(title: "Sign Up", onPressed: () async{
                        if(_formKey.currentState!.validate()) {
                          setState(() {
                            showSpinner = true;
                          });

                          try{

                            final userCreated = await _auth.createUserWithEmailAndPassword(email: email.toString().trim(), password: password.toString().trim());
                            toastMessage("User Successfully Created");
                            setState(() {
                              showSpinner = false;
                            },);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const OptionScreen(),),);
                          }on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage('The account already exists for that email.');
                            }
                          } catch (e) {
                            toastMessage(e.toString());
                          }
                        }
                      }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Al_Ready have an account/ ",
                            style: GoogleFonts.playfairDisplay(
                              color: textColor,
                              fontSize: 16,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                            },
                            child: Text(
                              "Log In",
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
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: roundButtonBorderColor,
        textColor: textColor,
        fontSize: 16.0
    );
  }
}
