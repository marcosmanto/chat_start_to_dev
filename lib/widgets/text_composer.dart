import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer({super.key, required this.onSendMessage});

  //final void Function(String) onSendMessage;
  final void Function({XFile? img, String? text}) onSendMessage;

  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isComposing = false;
  final _picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(
              onPressed: () async {
                final XFile? img =
                    await _picker.pickImage(source: ImageSource.camera);
                if (img == null) return;
                _submit(img: img, text: _controller.text);
              },
              icon: Icon(Icons.photo_camera)),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: 'Enviar uma mensagem'),
              onChanged: (text) {
                setState(() => _isComposing = text.isNotEmpty);
              },
              onSubmitted: (text) => _submit(text: text),
            ),
          ),
          IconButton(
              onPressed:
                  _isComposing ? () => _submit(text: _controller.text) : null,
              icon: Icon(Icons.send)),
        ],
      ),
    );
  }

  void _submit({String? text, XFile? img}) {
    widget.onSendMessage(text: text, img: img);
    _controller.clear();
    setState(() => _isComposing = false);
  }
}
