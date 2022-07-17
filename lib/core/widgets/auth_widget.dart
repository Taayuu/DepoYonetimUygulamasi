import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihhdepom/core/model/my_app_user.dart';
import 'package:ihhdepom/home_page.dart';
import 'package:ihhdepom/sign_in_page.dart';

import 'error_page.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key, required this.snapshot}) : super(key: key);
  final AsyncSnapshot<MyAppUser?> snapshot;
  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.active) {
      return snapshot.hasData
          ? HomePage(
              Qr: '',
              currentIndexs: 0,
              ID: '',
            )
          : const SignInPage();
    }
    return const ErrorPage();
  }
}
