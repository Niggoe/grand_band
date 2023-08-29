import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../dialogs/create_band_dialog.dart';

class BandHomePage extends StatefulWidget {
  @override
  _BandHomePageState createState() => _BandHomePageState();
}

class _BandHomePageState extends State<BandHomePage> {
  var user = FirebaseAuth.instance.currentUser!.uid;

  final Stream<QuerySnapshot> _bandStream = FirebaseFirestore.instance
      .collection('bands')
      .where("admin", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Bands"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add band',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogBox(
                        title: "Custom Dialog Demo",
                        descriptions:
                            "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
                        text: "Yes",
                      );
                    });
              }),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _bandStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
                padding: const EdgeInsets.all(12.0),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(data['name']),
                    subtitle: Text(data['slogan']),
                  );
                }).toList());
          }
        },
      ),
    );
    // print(user);
  }
}
