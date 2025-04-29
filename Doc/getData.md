```dart
import 'package:flutter/material.dart';
import 'firestore_service.dart';

class AddUser_Screen extends StatefulWidget {
  const AddUser_Screen({super.key});

  @override
  State<StatefulWidget> createState() => AddUser_Screen_State();
}

class AddUser_Screen_State extends State<AddUser_Screen> {
  final FireStore_Service fireStore_Service = FireStore_Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: Column(
        children: [
          // StreamBuilder for Firestore data
          Expanded(
            child: StreamBuilder(
              stream: fireStore_Service.getUser(),
              builder: (context, snp) {
                if (!snp.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // Data is available, render it in ListView
                return ListView(
                  children: snp.data!.docs.map<Widget>((doc) {
                    // Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    Map<String, dynamic> data= doc.data() as Map<String, dynamic>;
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
          )
        ],
      ),
    );
  }
}

``` 