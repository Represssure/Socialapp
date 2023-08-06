import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/profile_dialog.dart';
import 'screens/login_screen.dart';
import 'screens/profile_widget.dart';
import 'screens/map_screen.dart';
import 'screens/profile_dialog.dart';
import 'floating_action_button.dart';
import 'location_service.dart';
import 'map_service.dart';
import 'user_repository.dart';
import 'firebase_options.dart';
import 'main.dart';
import 'screens/messenger_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String nickname;
  final List<String> friends;
  final Function(String) onSaveNickname;
  final Function(String) onSearchUser;
  final Function(String) onSendFriendRequest;

  const CustomAppBar({
    required this.nickname,
    required this.friends,
    required this.onSaveNickname,
    required this.onSearchUser,
    required this.onSendFriendRequest,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void _openProfileDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProfileDialog(
          currentNickname: nickname,
          friends: friends,
          onSaveNickname: onSaveNickname,
          onSearchUser: onSearchUser,
          onSendFriendRequest: onSendFriendRequest,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Карта'),
      actions: [
        IconButton(
          onPressed: () => _openProfileDialog(context),
          icon: Icon(Icons.person),
        ),
        IconButton(
          icon: Icon(Icons.message),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VengamoChatScreen()),
            );
          },
        ),
      ],
    );
  }
}