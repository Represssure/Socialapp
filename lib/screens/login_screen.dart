import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map_screen.dart';
import 'package:zenlyapp/auth_manager.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    if (await AuthManager.isLoggedIn()) {
      _navigateToMapScreen();
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await AuthManager.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      _navigateToMapScreen();
    } catch (e) {
      print('Ошибка входа: $e');
    }
  }

  Future<void> _registerWithEmailAndPassword() async {
    try {
      await AuthManager.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _nicknameController.text,
      );

      _navigateToMapScreen();
    } catch (e) {
      print('Ошибка регистрации: $e');
    }
  }

  void _showNicknameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите никнейм'),
          content: TextField(
            controller: _nicknameController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Закрыть диалоговое окно без сохранения никнейма
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                String nickname = _nicknameController.text;
                if (nickname.isNotEmpty) {
                  _registerWithEmailAndPassword();
                  Navigator.pop(context); // Закрыть диалоговое окно после сохранения никнейма и регистрации
                }
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }


  void _navigateToMapScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _signInWithEmailAndPassword();
              },
              child: Text('Войти'),
            ),
            TextButton(
              onPressed: () {
                _showNicknameDialog();
              },
              child: Text('Регистрация'),
            ),
          ],
        ),
      ),
    );
  }
}
