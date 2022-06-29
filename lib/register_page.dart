import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  FirebaseAuth Auth = FirebaseAuth.instance;
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
            child: TextField(
              textCapitalization: TextCapitalization.words,
              controller: k_Adi,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black, width: 3)),
                  hintText: "Kullanıcı Adı",
                  hintStyle: TextStyle(color: Colors.grey[700])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (emailMtn) {
                emailStr = emailMtn;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black, width: 3)),
                  hintText: "E-Posta",
                  hintStyle: TextStyle(color: Colors.grey[700])),
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
                  prefixIcon: Icon(Icons.key),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.black, width: 3)),
                  hintText: "Şifre",
                  hintStyle: TextStyle(color: Colors.grey[700])),
            ),
          ),
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
                          if (passwordStr.length > 5) {
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .where("Kullanıcı Adı", isEqualTo: k_Adi.text)
                                .get()
                                .then((gelenVeri) async {
                              if (gelenVeri.docs.isEmpty) {
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
                                    "Emanetler": FieldValue.arrayUnion([]),
                                    "Id": Auth.currentUser!.uid,
                                    "Durum": 0,
                                  });
                                  emailStr = "";
                                  passwordStr = "";
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Bu kullanıcı adı zaten kullanılıyor",
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 20);
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Şifre en az 6 karakter olmalıdır",
                                gravity: ToastGravity.CENTER,
                                fontSize: 20);
                          }
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
