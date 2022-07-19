// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ihhdepom/core/service/firebaseKisayol.dart';
import 'package:ihhdepom/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'core/service/i_auth_service.dart';
import 'core/service/renk.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController k_Adi = TextEditingController();
  String passwordmtn2 = "";
  String verfyStr = "";
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      backgroundColor: anaRenk,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              textCapitalization: TextCapitalization.words,
              controller: k_Adi,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  fillColor: white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: black, width: 3)),
                  hintText: "Kullanıcı Adı",
                  hintStyle: const TextStyle(color: grey700)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              onChanged: (emailMtn) {
                emailStr = emailMtn;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail),
                  fillColor: white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: black, width: 3)),
                  hintText: "E-Posta",
                  hintStyle: const TextStyle(color: grey700)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (passwordMtn) {
                passwordStr = passwordMtn;
              },
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key),
                  fillColor: white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: black, width: 3)),
                  hintText: "Şifre",
                  hintStyle: const TextStyle(color: grey700)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (passwordMtn2) {
                passwordmtn2 = passwordMtn2;
              },
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key),
                  fillColor: white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: black, width: 3)),
                  hintText: "Şifre Tekrar",
                  hintStyle: const TextStyle(color: grey700)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              onChanged: (verfyMtn) {
                verfyStr = verfyMtn;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.verified_user),
                  fillColor: white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: const BorderSide(color: black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: black, width: 3)),
                  hintText: "Doğrulama Kodu",
                  hintStyle: const TextStyle(color: grey700)),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: MaterialButton(
                        child: const Text(
                          'İptal',
                          style: TextStyle(fontSize: 20, color: white),
                        ),
                        color: ikinciRenk,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
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
                        child: const Text(
                          'Kayıt Ol',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: const Color(0xffd41217),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("AppControl")
                              .doc("İnfo")
                              .get()
                              .then((valueVerfy) async {
                            if (verfyStr == valueVerfy.data()!["Verify"]) {
                              if (passwordStr.length > 5) {
                                await FirebaseFirestore.instance
                                    .collection("Users")
                                    .where("Kullanıcı Adı",
                                        isEqualTo: k_Adi.text)
                                    .get()
                                    .then((gelenVeri) async {
                                  if (gelenVeri.docs.isEmpty) {
                                    if (passwordStr == passwordmtn2) {
                                      await _authService
                                          .createUserWithEmailAndPassword(
                                              email: emailStr,
                                              password: passwordStr)
                                          .then((kullanici) {
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(emailStr)
                                            .set({
                                          "Eposta": emailStr,
                                          "Şifre": passwordStr,
                                          "Kullanıcı Adı": k_Adi.text,
                                          "Üye Olma Tarihi": DateTime.now(),
                                          "Emanetler":
                                              FieldValue.arrayUnion([]),
                                          "Id": Auth.currentUser!.uid,
                                          "Durum": 0,
                                        });
                                        emailStr = "";
                                        passwordStr = "";
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Girdiğiniz şifre aynı olmalıdır",
                                          gravity: ToastGravity.CENTER,
                                          fontSize: 20);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Bu kullanıcı adı zaten kullanılıyor",
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
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Doğrulama kodu hatalı",
                                  gravity: ToastGravity.CENTER,
                                  fontSize: 20);
                            }
                          });
                        }),
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
