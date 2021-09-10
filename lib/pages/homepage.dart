import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/addnote.dart';
import 'package:todo_app/pages/viewnote.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');

  List myColors = [
    Colors.yellow[700],
    Colors.red[200],
    Colors.green[200],
    Colors.purple[200],
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => AddNote(),
                ),
              )
              .then((value) => setState(() {}));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[600],
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Your Notes / Todos",
          style: TextStyle(
              fontSize: 27.0,
              fontFamily: "lato",
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Random random = new Random();
                  Color bg = myColors[random.nextInt(4)];
                  Map data = snapshot.data!.docs[index].data() as Map;
                  DateTime myDateTime = data['created'].toDate();
                  String formattedTime = DateFormat.yMMMd().add_jm().format(myDateTime);

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewNote(data, formattedTime, snapshot.data!.docs[index].reference),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    child: Card(
                      color: bg,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data['title']}",
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: "lato",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                formattedTime,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "lato",
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
    );
  }
}
