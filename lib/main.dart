import 'package:bolg_app/firebase_options.dart';
import 'package:bolg_app/screens/add_post.dart';
import 'package:bolg_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()  {

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        iconTheme: const IconThemeData(
          color: Colors.white,
        )
      ),
      home:  const AddPostScreen(),
    );
  }
}


