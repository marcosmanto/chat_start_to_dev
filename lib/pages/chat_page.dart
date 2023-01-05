import 'package:chat_start_to_dev/widgets/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  void _sendMessage(String text) {
    FirebaseFirestore.instance.collection('messages').add({
      'text': text,
    });
  }
}
