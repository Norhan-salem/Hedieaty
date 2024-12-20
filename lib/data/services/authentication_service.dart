import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static const _loginTimeKey = 'login_time';

  Future<void> logLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_loginTimeKey, currentTime);
    print("Login time set: $currentTime");
  }

  Future<int?> getLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    int? loginTime = prefs.getInt(_loginTimeKey);
    print("Retrieved login time: $loginTime");
    return loginTime;
  }

  Future<User?> registerUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<bool> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      print('${_firebaseAuth.currentUser?.uid}');
      if (firebaseUser == null) {
        print('No user is logged in.');
        return null;
      }
      print('${_firebaseAuth.currentUser?.uid}');
      return _firebaseAuth.currentUser;
    } catch (e) {
      throw Exception('Failed to fetch current user: $e');
    }
  }
}
