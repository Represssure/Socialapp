import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/profile_dialog.dart';
import 'screens/login_screen.dart';
import 'screens/profile_widget.dart';
import 'screens/map_screen.dart';

class UserRepository {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot?> findUserByNickname(String nickname) async {
    try {
      QuerySnapshot querySnapshot =
      await _usersCollection.where('nickname', isEqualTo: nickname).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      } else {
        return null;
      }
    } catch (e) {
      print('Ошибка поиска пользователя: $e');
      return null;
    }
  }

  Future<void> sendFriendRequest(String currentUserId, String friendId) async {
    try {
      DocumentReference currentUserDoc = _usersCollection.doc(currentUserId);
      DocumentReference friendDoc = _usersCollection.doc(friendId);

      await currentUserDoc.update({'friends': FieldValue.arrayUnion([friendId])});
      await friendDoc.update({'friendRequests': FieldValue.arrayUnion([currentUserId])});
    } catch (e) {
      print('Ошибка отправки приглашения другу: $e');
    }
  }
}
