import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


String? validateEmail(String value) {
  if (value.isEmpty) {
    return 'Email is Required';
  }
  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
    return 'Invalid Email';
  }
  return null;
}

String? validatePassword(String value) {
  if (value.isEmpty) {
    return 'Password is Required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}


Future<void> signUpWithEmailAndPassword(String email, String password) async {
  try {
    //validate the email and password before sending the request to firebase
    if (email == null || email.isEmpty) {
      throw ("Email cannot be empty");
    }
    if (!email.contains("@")) {
      throw ("Invalid Email");
    }
    if (password == null || password.isEmpty) {
      throw ("Password cannot be empty");
    }
    if (password.length < 6) {
      throw ("Password must be at least 6 characters");
    }

    // send the request to firebase
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    assert(user != null);
    assert(await user!.getIdToken() != null);
  } catch (e) {
    throw (e);
  }
}




Future<void> loginWithEmailAndPassword(String email, String password) async {
  try {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    assert(user != null);
    assert(await user!.getIdToken() != null);
  } catch (e) {
    throw (e);
  }
}