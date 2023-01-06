import 'dart:io';

import 'package:chat_start_to_dev/widgets/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Olá'),
        centerTitle: true,
      ),
      body: TextComposer(
        onSendMessage: _sendMessage,
      ),
    );
  }

  void _sendMessage({String? text, XFile? img}) async {
    Map<String, dynamic> data = {};

    if (img != null) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(File(img.path));
      TaskSnapshot taskSnapshot = await task.whenComplete(() => null);
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
    }

    data['text'] = text;
    FirebaseFirestore.instance.collection('messages').add(data);
  }
}
