import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihhdepom/core/model/my_app_user.dart';
import 'package:ihhdepom/core/service/i_auth_service.dart';
import 'package:ihhdepom/core/service/mixin_user.dart';

class AuthService with ConvertUser implements IAuthService {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  MyAppUser _getUser(User? user) {
    return MyAppUser(userId: user!.uid, userMail: user.email!);
  }

  @override
  Future<MyAppUser> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    var _tempUser = await _authInstance.createUserWithEmailAndPassword(
        email: email, password: password);
    return convertUser(_tempUser);
  }

  @override
  Stream<MyAppUser?> get onAuthStateChange =>
      _authInstance.authStateChanges().map(_getUser);

  @override
  Future<MyAppUser> signInEmailAndPassword(
      {required String email, required String password}) async {
    var _tempUser = await _authInstance.signInWithEmailAndPassword(
        email: email, password: password);
    return convertUser(_tempUser);
  }

  @override
  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}
