import 'package:chat/widgets/chat/messages.dart';
import 'package:chat/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter chat'),
        actions: [
          PopupMenuButton(
            onSelected: (val) {
              if (val == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'Logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                ),
              )
            ],
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            const NewMessage(),
          ],
        ),
      ),
    );
  }
}
