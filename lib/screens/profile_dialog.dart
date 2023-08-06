import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenlyapp/friend_requests.dart';
import 'package:zenlyapp/screens/auth_profile.dart';
import 'login_screen.dart';
import 'package:zenlyapp/auth_manager.dart';

class ProfileDialog extends StatelessWidget {
  final String? currentNickname;
  final List<String> friends;
  final Function(String) onSaveNickname;
  final Function(String) onSearchUser;
  final Function(String) onSendFriendRequest;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ProfileDialog({
    this.currentNickname,
    required this.friends,
    required this.onSaveNickname,
    required this.onSearchUser,
    required this.onSendFriendRequest,
  }
  );

  Future<void> sendFriendRequest(String userId) async {
    String? userNickname = await AuthManager.getCurrentUserNickname(); // Получаем никнейм текущего пользователя
    if (userNickname != null) { // Если никнейм существует
      return firestore.collection('users').doc(userId).set({
        'requests': FieldValue.arrayUnion([userNickname])
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _nicknameController = TextEditingController();
    final _searchController = TextEditingController();

    _nicknameController.text = currentNickname ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
        actions: [
          TextButton(
            onPressed: () {
              onSaveNickname(_nicknameController.text);
              Navigator.pop(context);
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Никнейм:'),
            TextField(
              controller: _nicknameController,
            ),
            SizedBox(height: 16),
            Text('Друзья:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: friends.map((friend) => Text(friend)).toList(),
            ),
            SizedBox(height: 16),
            Text('Поиск пользователя по никнейму:'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String nickname = _searchController.text;
                    DocumentSnapshot? userSnapshot = await onSearchUser(nickname);
                    if (userSnapshot != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Пользователь найден'),
                            content: Text('Хотите отправить приглашение пользователю "${userSnapshot['nickname']}"?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Отмена'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  sendFriendRequest(userSnapshot.id);
                                  onSendFriendRequest(userSnapshot.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Отправить приглашение'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Пользователь не найден'),
                            content: Text('Пользователь с никнеймом "$nickname" не найден.'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Ок'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Найти'),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text('Приглашения'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendRequests(currentUserId: 'currentUserId')), // Замените 'currentUserId' на идентификатор текущего пользователя
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Вход'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthProfile()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
