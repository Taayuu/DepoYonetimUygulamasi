// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/forgot_password.dart';
import 'package:login/register_page.dart';
import 'package:provider/provider.dart';

import 'core/service/i_auth_service.dart';

List<DocumentSnapshot>? malzemeler;
String emailStr = "";
String passwordStr = "";
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List malzemeler = [""];
    final _authService = Provider.of<IAuthService>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xffFFEBC1),
          body: Form(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Expanded(child: Image.asset("assets/ihh_logo.png")),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (emailMtn) {
                                  emailStr = emailMtn;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person),
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2)),
                                    hintText: "Kullanıcı Adı",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700])),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (passwordMtn) {
                                  passwordStr = passwordMtn;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.key),
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2)),
                                    hintText: "Şifre",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700])),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RegisterPage()));
                                      },
                                      child: const Text(
                                        'Hesap\nOluştur',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: MaterialButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("Users")
                                              .where("Eposta",
                                                  isEqualTo: emailStr)
                                              .get()
                                              .then((gelenVeri) async {
                                            if (gelenVeri.docs.isNotEmpty) {
                                              await _authService
                                                  .signInEmailAndPassword(
                                                      email: emailStr,
                                                      password: passwordStr);
                                              Fluttertoast.showToast(
                                                  msg: "Giriş Yapıldı",
                                                  gravity: ToastGravity.CENTER,
                                                  fontSize: 20);
                                              emailStr = "";
                                              passwordStr = "";
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Eposta veya şifre yanlış",
                                                  gravity: ToastGravity.CENTER,
                                                  fontSize: 20);
                                            }
                                          });
                                        },
                                        color: const Color(0xffd41217),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 20),
                                        child: const Text(
                                          'Giriş',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                        child: const Text(
                                          "Şifremi\nUnuttum",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPassword()));
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
