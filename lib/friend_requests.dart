import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenlyapp/auth_manager.dart';

class FriendRequests extends StatelessWidget {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  FriendRequests({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Приглашения'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('invitations')
            .where('recipientId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Произошла ошибка: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.data!.docs.isEmpty) {
            return Text('Нет приглашений');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String senderNickname = data['senderNickname'];
              return ListTile(
                title: Text('Приглашение от $senderNickname'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Принять приглашение
                        document.reference.delete();
                      },
                      child: Text('Принять'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Отклонить приглашение
                        document.reference.delete();
                      },
                      child: Text('Отклонить'),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}