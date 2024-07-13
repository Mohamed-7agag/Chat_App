import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._privateConstructor();

  // Singleton instance
  static final AuthService instance = AuthService._privateConstructor();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;
}
