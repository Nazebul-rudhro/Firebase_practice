import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

class Phone_verify extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Phone_verifyState();
  }

}

class Phone_verifyState extends State<Phone_verify>{
  TextEditingController phoneController = TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  PhoneVerify()async{
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber:phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential)async{
          var result = await _firebaseAuth.signInWithCredential(credential);
          User? user = result.user;
          if(user != null){
            print("Phone Number Automatically verified and user signed in ${user.phoneNumber}");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
          }
        },
        timeout: Duration(seconds: 60),
        verificationFailed: (FirebaseAuthException e){
          print("Verification Failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code sent to phone");
        },
        codeAutoRetrievalTimeout: (String verificationId){}
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Phone Verify"),
              SizedBox(height: 15,),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Enter your Number",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)
                  )
        
        
                ),
              ),
              ElevatedButton(onPressed: (){
                PhoneVerify();
              }, child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }

}