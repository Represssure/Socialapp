import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final String nickname; // Никнейм пользователя
  final void Function(String)? onSaveNickname; // Функция для сохранения нового никнейма

  ProfileWidget({required this.nickname, this.onSaveNickname});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.nickname);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Профиль',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _nicknameController,
            decoration: InputDecoration(labelText: 'Никнейм'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Вызываем функцию onSaveNickname и передаем новый никнейм
              widget.onSaveNickname?.call(_nicknameController.text);
              Navigator.pop(context); // Закрываем диалоговое окно профиля
            },
            child: Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
