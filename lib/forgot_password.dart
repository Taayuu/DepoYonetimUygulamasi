// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ihhdepom/core/service/firebaseKisayol.dart';
import 'core/service/renk.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String emailStr = "";
    return Scaffold(
      backgroundColor: anaRenk,
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
                          'Şifreyi Sıfırla',
                          style: TextStyle(fontSize: 20, color: white),
                        ),
                        color: ikinciRenk,
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
