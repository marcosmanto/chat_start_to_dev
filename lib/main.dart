// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());

  await Firebase.initializeApp();

  // Listen to a collection
  /*FirebaseFirestore.instance.collection('mensagens').snapshots().listen((msgs) {
    msgs.docs.forEach((doc) => print(doc.data()));
  });*/

  // Listen to a specific document
  FirebaseFirestore.instance
      .collection('mensagens')
      .doc('0bfjglLd47egwZwGNfkb')
      .snapshots()
      .listen((doc) {
    print(doc.data());
  });

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('mensagens')
      .orderBy('time', descending: false)
      .get();
  List docs = snapshot.docs.map((doc) => doc.data()).toList();
  print(docs);

  // batch update/create a property of a document
  snapshot.docs.forEach((doc) => doc.reference.update({'read': true}));

  DocumentSnapshot snapshotDoc = await FirebaseFirestore.instance
      .collection('mensagens')
      .doc('PwRqMMY3Z133R1ZSOYxr')
      .get();
  print(snapshotDoc.data());
  print(snapshotDoc.id);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
