import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zenlyapp/screens/login_screen.dart';

class AuthManager {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  static Future<bool> isLoggedIn() async {
    final User? user = await getCurrentUser();
    return user != null;
  }

  static Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _prefs!.setString('userId', userCredential.user!.uid);
    } catch (e) {
      print('Ошибка входа: $e');
    }
  }

  static Future<void> registerWithEmailAndPassword(String email, String password, String nickname) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid; // Получаем идентификатор пользователя

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'nickname': nickname,
      });

      await _prefs!.setString('userId', userId);
    } catch (e) {
      print('Ошибка регистрации: $e');
    }
  }

  static Future<String?> getCurrentUserNickname() async {
    final User? user = await getCurrentUser();
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return doc['nickname'];
    }
    return null;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await _prefs!.remove('userId');
  }
}