import 'package:firebase_auth/firebase_auth.dart';

import '../model/my_app_user.dart';

mixin ConvertUser {
  MyAppUser convertUser(UserCredential user) {
    return MyAppUser(userId: user.user!.uid, userMail: user.user!.email!);
  }
}
