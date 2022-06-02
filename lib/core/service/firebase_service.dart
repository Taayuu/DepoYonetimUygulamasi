import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/core/model/my_app_user.dart';
import 'package:login/core/service/i_auth_service.dart';
import 'package:login/core/service/mixin_user.dart';

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
/*
class MaterialService implements IMaterialsAddService {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Future<MyAppUserMaterials> createMaterialsWithQr(
      {required String materialId,
      required int materialQr,
      required String materialClass,
      required String materiaName,
      required String materialDepartment,
      required String materialReceiver,
      required String materialDelivery,
      required DateTime materialPurchaseDate,
      required DateTime materialReturnDate}) async {
    var _tempUser = await _initialization.createMaterialsWithQr(
        email: email, password: password);
    return _tempUser;
  }
}*/
