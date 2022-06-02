import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/register_page.dart';
import 'package:provider/provider.dart';

import 'core/service/i_auth_service.dart';

List<DocumentSnapshot>? malzemeler;
String emailStr = "";
String passwordStr = "";
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
          backgroundColor: Color(0xffFFEBC1),
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: TextField(
                                  onChanged: (emailMtn) {
                                    emailStr = emailMtn;
                                  },
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: "E-Posta"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  child: TextField(
                                    onChanged: (passwordMtn) {
                                      passwordStr = passwordMtn;
                                    },
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.key,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: InputBorder.none,
                                        hintText: "Şifre"),
                                  ),
                                ),
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
                                                    RegisterPage()));
                                        /*await _authService
                                            .createUserWithEmailAndPassword(
                                                email: emailStr,
                                                password: passwordStr)
                                            .then((kullanici) {
                                          FirebaseAuth Auth =
                                              FirebaseAuth.instance;
                                          FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(emailStr)
                                              .set({
                                            "Eposta": emailStr,
                                            "Şifre": passwordStr,
                                            "Kullanıcı Adı": "",
                                            "Üye Olma Tarihi": DateTime.now(),
                                            "Emanetler": FieldValue.arrayUnion(
                                                malzemeler),
                                            "Id": Auth.currentUser!.uid,
                                          });
                                          emailStr = "";
                                          passwordStr = "";
                                        });*/
                                      },
                                      child: Text(
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
                                          await _authService
                                              .signInEmailAndPassword(
                                                  email: emailStr,
                                                  password: passwordStr);
                                          Fluttertoast.showToast(
                                              msg: "Giriş Yapıldı.");
                                          emailStr = "";
                                          passwordStr = "";
                                        },
                                        color: Color(0xffd41217),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 20),
                                        child: const Text(
                                          'Üye Girişi',
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
                                          _scaffoldKey.currentState
                                              ?.showSnackBar(SnackBar(
                                                  backgroundColor: Colors.black,
                                                  content: Row(
                                                    children: const <Widget>[
                                                      Text(
                                                        "Unutmasaydın ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Icon(
                                                        Icons.tag_faces_sharp,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  )));
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
