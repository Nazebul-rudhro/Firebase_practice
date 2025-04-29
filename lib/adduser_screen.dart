import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice/login.dart';
import 'firestore_service.dart';

class AddUser_Screen extends StatefulWidget {
  final UserCredential user;
  const AddUser_Screen({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => AddUser_Screen_State();
}

class AddUser_Screen_State extends State<AddUser_Screen> {
  final FireStore_Service fireStore_Service = FireStore_Service();

  // Logout function
  Logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print("Logout failed: $e");
    }
  }

  // User deletion function
  Future<void> deleteUser() async {
    try {
      await widget.user.user!.delete();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print("Please re-authenticate and try again");
      } else {
        print("Error during user deletion: ${e.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: Column(
        children: [
          // Display User Details
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (widget.user.user != null)
                  Column(
                    children: [
                      Text('UID: ${widget.user.user!.uid}'),
                      Text('Email: ${widget.user.user!.email ?? "No Email"}'),
                    ],
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: Logout,
                  child: Text("Logout"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: deleteUser,
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ),

          // StreamBuilder for Firestore data
          Expanded(
            child: StreamBuilder(
              stream: fireStore_Service.getUser(), // Ensure this is working
              builder: (context, snp) {
                if (!snp.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Data is available, render it in ListView
                return ListView(
                  children: snp.data!.docs.map<Widget>((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(data['name'] ?? "No Name"),
                        subtitle: Text(data['email'] ?? "No Email"),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
