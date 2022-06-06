import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/sign_in_page.dart';
import 'package:provider/provider.dart';

import 'core/service/i_auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController k_Adi = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xffFFEBC1),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                controller: k_Adi,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  hintText: "Kullanıcı Adı",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextField(
                onChanged: (emailMtn) {
                  emailStr = emailMtn;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  hintText: "E-Posta",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextField(
                onChanged: (passwordMtn) {
                  passwordStr = passwordMtn;
                },
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  hintText: "Şifre",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
              ),
            ),
          ),
          /*  Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                        hintText: "Şifre Tekrar"),
                  ),
                ),
              ),*/
          SizedBox(
            height: 35,
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: MaterialButton(
                        child: Text(
                          'İptal',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: Color(0xffd41217),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: MaterialButton(
                        child: Text(
                          'Kayıt Ol',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: Color(0xffd41217),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        onPressed: () async {
                          await _authService
                              .createUserWithEmailAndPassword(
                                  email: emailStr, password: passwordStr)
                              .then((kullanici) {
                            FirebaseAuth Auth = FirebaseAuth.instance;
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(emailStr)
                                .set({
                              "Eposta": emailStr,
                              "Şifre": passwordStr,
                              "Kullanıcı Adı": k_Adi.text,
                              "Üye Olma Tarihi": DateTime.now(),
                              "Emanetler": "",
                              "Id": Auth.currentUser!.uid,
                              "Durum": 0,
                            });
                            emailStr = "";
                            passwordStr = "";
                          });
                        }),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
