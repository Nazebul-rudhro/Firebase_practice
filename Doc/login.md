```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:practice/adduser_screen.dart';
import 'package:practice/register.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }

}

class LoginPageState  extends State<LoginPage>{
  var email;
  var password;
  void userLogin(String email, String password)async{
          try{
            FirebaseAuth firebaseAuth = FirebaseAuth.instance;
            UserCredential userCredential =await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
              User? user = userCredential.user;
              if(user != null){
                print("Login Successfully");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddUser_Screen(user: userCredential)));
              }
          }on FirebaseAuthException catch (e){
            print("Firebase login error ${e.code} - ${e.message}");
          }catch(e){
          print("Error ${e}");
          }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Log In"),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: "Enter your email",
                  labelText: "Email"
                ),onChanged: (value){
                  setState(() {
                    email = value;
                  });
              },
              ),

              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.password),
                  hintText: "Enter your Password",
                  labelText: "Password"
                ),onChanged: (value){
                  setState(() {
                    password = value;
                  });
              },
              ),
              ElevatedButton(onPressed: (){
                if(email != null && password != null){
                  userLogin(email, password);
                }

              }, child: Text("Login")),
              RichText(
                text: TextSpan(
                  text: "If you have no account? Please ",
                  style: TextStyle(color: Colors.black), // Text color দিতে হবে
                  children: [
                    TextSpan(
                      text: "registration",
                      style: TextStyle(color: Colors.blueAccent),
                      recognizer: TapGestureRecognizer()
                        ..onTap = (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                    },


                    ),
                  ],
                ),
              )


            ],

        ),
      ) ,
    );
  }
}
```