// ignore_for_file: avoid_print

import 'dart:io';

import 'package:chat_start_to_dev/widgets/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double? _snackPosition;
  bool _isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //User? _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        print('user already logged');
        // TODO: recheck user when screen builds
        print(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    _snackPosition = _snackPosition ?? MediaQuery.of(context).size.height - 120;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(FirebaseAuth.instance.currentUser != null
              ? 'Olá, ${FirebaseAuth.instance.currentUser!.displayName}'
              : 'Chat App'),
          centerTitle: true,
          actions: [
            FirebaseAuth.instance.currentUser != null
                ? IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await googleSignIn.signOut();
                      _displaySnack('Você saiu com sucesso.');
                      setState(() {});
                    },
                    icon: Icon(Icons.exit_to_app),
                  )
                : Container()
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      var documents = snapshot.data?.docs;

                      if (FirebaseAuth.instance.currentUser != null &&
                          documents != null &&
                          documents.isNotEmpty) {
                        return ListView.builder(
                          itemCount: documents.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return ChatMessage(
                              message: documents[index].data(),
                              mine: documents[index].data()['uid'] ==
                                  FirebaseAuth.instance.currentUser?.uid,
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(FirebaseAuth.instance.currentUser != null
                                  ? 'Nenhuma mensagem ainda'
                                  : 'Faça login para ver as mensagens'),
                              Icon(Icons.sentiment_satisfied_alt)
                            ],
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            if (_isLoading)
              LinearProgressIndicator()
            else
              TextComposer(
                onSendMessage: _sendMessage,
              ),
          ],
        ),
      ),
    );
  }

  void _displaySnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(16),
        ),
        margin:
            EdgeInsets.only(bottom: _snackPosition ?? 0, right: 20, left: 20),
        backgroundColor: Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.warning,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                msg,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage({String? text, XFile? img}) async {
    if ((text == null || text.trim().isEmpty) && img == null) {
      _displaySnack('Digite uma mensagem ou tire uma foto');
      return;
    }

    final User? user = await _getUser();

    if (user == null) {
      _displaySnack('Não foi possível fazer o login. Tente novamente.');
      return;
    }

    Map<String, dynamic> data = {
      'uid': user.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL
    };

    if (img != null) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(
              '${user.uid}_${DateTime.now().millisecondsSinceEpoch.toString()}')
          .putFile(File(img.path));
      setState(() => _isLoading = true);
      TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
      setState(() => _isLoading = false);
    }

    data['text'] = text;
    data['createdAt'] = DateTime.now().toIso8601String();
    FirebaseFirestore.instance.collection('messages').add(data);
  }

  Future<User?> _getUser() async {
    //if (_currentUser != null) return _currentUser;
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser;
    }

    late final User? user;

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        // signInWithCredential works for google, facebook, linkedin, etc
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);

        user = userCredential.user;
        // rebuild screen to show the messages for authenticated user
        setState(() {});
      } else {
        user = null;
      }
    } catch (e) {
      print(e.toString());
    }
    return user;
  }
}
