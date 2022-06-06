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
      backgroundColor: Color(0xffFFEBC1),
      body: Form(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  hintText: "Email",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                ),
                onChanged: (emailMtn) {
                  emailStr = emailMtn;
                },
              ),
            ),
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
                          'Şifreyi Sıfırla',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: Color(0xffd41217),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        onPressed: () {
                          Auth.sendPasswordResetEmail(email: emailStr);
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                              msg: "Sıfırlama linki mail adresine gönderildi.");
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
