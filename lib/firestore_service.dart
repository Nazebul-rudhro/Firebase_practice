import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore_Service{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void>  addUser(String name, String roll, String email, String country) async{
    try{
      await _db.collection('user').add({
        "name" : name,
        "roll" : roll,
        "email" : email,
        "country" : country,
      });
    }catch(e){
      print("Error adding $e");
    }

  }
  Stream<QuerySnapshot> getUser(){
    return _db.collection('user').snapshots();
  }
}