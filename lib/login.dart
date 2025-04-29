import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practice/adduser_screen.dart';
import 'package:practice/register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  var email;
  var password;

  // Firebase login function
  void userLogin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      print("Email and password cannot be empty.");
      return;
    }

    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        print("Login Successfully");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AddUser_Screen(user: userCredential))); // Pass UserCredential here
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase login error ${e.code} - ${e.message}");
    } catch (e) {
      print("Error ${e}");
    }
  }

  // Google login function
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google Sign-In process
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      if (googleSignInAccount == null) {
        // If the user cancels the sign-in
        print("Google Sign-in canceled");
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print("Error during Google sign-in: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Log In"),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                hintText: "Enter your email",
                labelText: "Email",
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.password),
                hintText: "Enter your Password",
                labelText: "Password",
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (email != null && password != null) {
                  userLogin(email, password);
                }
              },
              child: Text("Login"),
            ),
            RichText(
              text: TextSpan(
                text: "If you have no account? Please ",
                style: TextStyle(color: Colors.black), // Text color
                children: [
                  TextSpan(
                    text: "registration",
                    style: TextStyle(color: Colors.blueAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Register()));
                      },
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                UserCredential? userCredential = await signInWithGoogle();
                if (userCredential != null) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          AddUser_Screen(user: userCredential))); // Pass UserCredential here
                } else {
                  print("Google Login failed");
                }
              },
              child: Text("Continue with Google"),
            ),
          ],
        ),
      ),
    );
  }
}
