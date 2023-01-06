// ignore_for_file: avoid_print

import 'package:chat_start_to_dev/pages/chat_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/*Future<FirebaseApp> _init() async {
  await Future.delayed(Duration(seconds: 5));
  return Firebase.initializeApp();
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            iconTheme: IconThemeData(color: Colors.blue)),
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 224, 245, 255),
          body: FutureBuilder(
              future: Firebase.initializeApp(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                  case ConnectionState.active:
                    return ChatPage();
                }
              }),
        ));
  }
}
