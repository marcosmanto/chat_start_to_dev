import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  TextComposer({super.key, required this.onSendMessage});

  final void Function(String) onSendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.photo_camera)),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: 'Enviar uma mensagem'),
              onChanged: (text) {
                setState(() => _isComposing = text.isNotEmpty);
              },
              onSubmitted: _submit,
            ),
          ),
          IconButton(
              onPressed: _isComposing ? () => _submit(_controller.text) : null,
              icon: Icon(Icons.send)),
        ],
      ),
    );
  }

  void _submit(text) {
    widget.onSendMessage(text);
    _controller.clear();
    setState(() => _isComposing = false);
  }
}
