import 'dart:html';

import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<dynamic>(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = streamSnapshot.data.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => ChatBubble(
                message: chatDocs[index]['text'],
                isMe: chatDocs[index]['userId'] == futureSnapshot.data.uid,
                key: ValueKey(chatDocs[index].documentId),
              ),
            );
          },
        );
      },
    );
  }
}
