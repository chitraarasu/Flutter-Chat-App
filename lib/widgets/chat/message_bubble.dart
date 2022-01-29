import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageBubble extends StatelessWidget {
  final message;
  final isMe;
  final username;
  final imageURL;
  MessageBubble(this.message, this.isMe, this.username, this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Colors.pink,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 8,
              ),
              width: 250,
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    '$username',
                    style: TextStyle(
                      color: isMe ? Colors.pink : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: isMe ? null : -12,
              top: -12,
              left: !isMe ? null : -12,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.deepPurple,
                backgroundImage: NetworkImage(imageURL),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
