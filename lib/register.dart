import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'adduser_screen.dart';

class Register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterPage();
  }

}

class RegisterPage  extends State<Register>{
  String? email;
  String? password;
  registerUser(String email, String password)async{
   try{
     FirebaseAuth firebaseAuth = FirebaseAuth.instance;
     final UserCredential userCredential= await firebaseAuth.createUserWithEmailAndPassword(
         email: email,
         password: password
     );

     User? user = userCredential.user;
     if(user != null){
       Navigator.push(context, MaterialPageRoute(
           builder: (context)=>AddUser_Screen(user: userCredential)));
     }
   }catch(e){
     print("Registration Faild. $e");
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
            Text("Register"),
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
                  icon: Icon(Icons.lock),
                  hintText: "Enter your Password",
                  labelText: "Password"
              ),onChanged: (value){
                setState(() {
                  password = value;
                });
            },
            ),
            ElevatedButton(onPressed:(){
              if(email != null &&  password != null){
                registerUser(email!, password!);
              }else{
                print("Email and Password is Null");
              }
            }, child: Text("Register")),



          ],

        ),
      ) ,
    );
  }
}