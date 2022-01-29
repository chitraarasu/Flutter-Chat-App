import 'package:chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future _getCurrentUser() async {
      return FirebaseAuth.instance.currentUser;
    }

    return FutureBuilder(
      future: _getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final docs = snapshot.data.docs;
              return ListView.builder(
                reverse: true,
                itemCount: docs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  docs[index]['text'],
                  docs[index]['userId'] == futureSnapshot.data.uid,
                  docs[index]['username'],
                  docs[index]['userImage'],
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }
}
