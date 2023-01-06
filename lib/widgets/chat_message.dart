import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool mine;
  const ChatMessage({super.key, required this.message, required this.mine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: mine ? Colors.lightBlue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(message['senderPhotoUrl']),
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...[
                  if (message['imgUrl'] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Image.network(
                        message['imgUrl'],
                      ),
                    ),
                  if (message['text'] != null)
                    Text(
                      message['text'],
                      style: TextStyle(fontSize: 16),
                    )
                ],
                SizedBox(height: 6),
                Text(
                  message['senderName'],
                  style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
