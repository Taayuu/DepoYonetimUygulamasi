// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String emailStr = "";
    FirebaseAuth Auth = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: const Color(0xffFFEBC1),
      body: Form(
          child: Column(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 3)),
                  hintText: "E-Posta",
                  hintStyle: TextStyle(color: Colors.grey[700])),
              onChanged: (emailMtn) {
                emailStr = emailMtn;
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: MaterialButton(
                        child: const Text(
                          'İptal',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: const Color(0xffd41217),
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
                          'Şifreyi Sıfırla',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: const Color(0xffd41217),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        onPressed: () {
                          Auth.sendPasswordResetEmail(email: emailStr);
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                              msg: "Sıfırlama linki mail adresine gönderildi",
                              gravity: ToastGravity.CENTER,
                              fontSize: 20);
                        }),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
