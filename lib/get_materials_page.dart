import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:login/profile_page.dart';
import 'package:login/scan_qr_get.dart';

import 'home_page.dart';

class GetMaterials extends StatefulWidget {
  const GetMaterials(
      {Key? key,
      required this.Qr,
      required this.teslimal,
      required this.teslimet,
      required this.gerigel})
      : super(key: key);
  final String Qr;
  final bool teslimal;
  final bool teslimet;
  final bool gerigel;

  @override
  State<GetMaterials> createState() => _GetMaterialsState();
}

class _GetMaterialsState extends State<GetMaterials> {
  final _firestore = FirebaseFirestore.instance;

  FirebaseAuth Auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var sira;
    var malzemeAdi;
    final docRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth.currentUser!.email);
    var k_adi;
    FirebaseFirestore.instance.collection('Users');
    docRef.snapshots().listen((event) {
      k_adi = event.data()!["Kullanıcı Adı"];
    });
    FirebaseFirestore.instance.collection('Users');
    docRef.snapshots().listen((event) {
      sira = event.data()!["sira"];
    });
    Query qmaterials = FirebaseFirestore.instance
        .collection("Materials")
        .where("Qr Kod", isEqualTo: widget.Qr);
    final depRef = FirebaseFirestore.instance
        .collection("Deposit")
        .doc(Auth.currentUser!.email)
        .collection("Emanetlerim")
        .doc(Auth.currentUser!.email);

    List<DocumentSnapshot>? malzemeler;
    return Scaffold(
      backgroundColor: Color(0xffFFEBC1),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 100,
                width: 200,
                child: ClipRRect(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.black, width: 2)),
                    color: Colors.white,
                    elevation: 500,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ScanQrGet()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.qr_code_scanner_sharp,
                            color: Colors.black,
                            size: 50,
                          ),
                          Text(
                            "Qr İle Malzeme Seç",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: qmaterials.snapshots(),
              builder: (context, snp) {
                if (snp.hasError) {
                  return Center(
                    child: Text("Bir Hata Oluştu Tekrar Deneyiniz"),
                  );
                } else {
                  if (snp.hasData) {
                    malzemeler = snp.data!.docs;
                    return Flexible(
                      child: ListView.builder(
                        itemCount: malzemeler?.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side:
                                    BorderSide(color: Colors.black, width: 2)),
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                '${malzemeler?[index]['Malzeme Adı']}',
                                style: TextStyle(fontSize: 26),
                              ),
                              subtitle: Text(
                                '${malzemeler?[index].data()}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            ),
            Visibility(
              visible: widget.teslimal,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(Auth.currentUser!.email)
                            .update({
                          "Emanetler": FieldValue.arrayUnion(
                              [malzemeler?[0]["Malzeme Adı"]])
                        });
                      } catch (Exception) {}

                      FirebaseFirestore.instance.collection('Users');
                      docRef.snapshots().listen(
                        (event) {
                          k_adi = event.data()!["Kullanıcı Adı"];
                        },
                        onError: (error) => print("Listen failed: $error"),
                      );

                      FirebaseFirestore.instance
                          .collection('Materials')
                          .doc(malzemeler?[0]['Malzeme Adı'])
                          .update({"Konum": k_adi});

                      await FirebaseFirestore.instance
                          .collection('Deposit')
                          .doc(Auth.currentUser!.email)
                          .collection("Emanetlerim")
                          .doc(Auth.currentUser!.email)
                          .set({
                        "Emanet Adı": "${malzemeler?[0]["Malzeme Adı"]}",
                        "Emanet Alma Tarihi":
                            "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
                        "Emanet Alan": "${k_adi}"
                      });

                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(Auth.currentUser!.email)
                          .update({"sira": sira + 1});
                      Fluttertoast.showToast(
                          msg: "Malzeme Başarıyla Teslim Alındı.");
                    },
                    color: Color(0xffd41217),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Text(
                      'Malzemeyi Teslim Al',
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.teslimet,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: MaterialButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Users')
                          .doc(Auth.currentUser!.email)
                          .update({
                        "Emanetler": FieldValue.arrayRemove(
                            [malzemeler?[0]["Malzeme Adı"]])
                      });

                      FirebaseFirestore.instance
                          .collection('Materials')
                          .doc(malzemeler?[0]['Malzeme Adı'])
                          .update({"Konum": "Depo"});

                      FirebaseFirestore.instance
                          .collection('Deposit')
                          .doc(Auth.currentUser!.email)
                          .collection("Emanetlerim")
                          .doc(Auth.currentUser!.email)
                          .update({
                        "Teslim Tarihi":
                            "${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
                      });
                      depRef.snapshots().listen((event) {
                        malzemeAdi = event.data()!["Emanet Adı"];
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            malzeme: malzemeAdi,
                          ),
                        ),
                      );
                      Fluttertoast.showToast(
                          msg: "Malzeme Başarıyla Teslim Edildi.");
                    },
                    color: Color(0xffd41217),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Text(
                      'Malzemeyi Teslim Et',
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.gerigel,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FloatingActionButton(
                      child: Icon(Icons.arrow_back, size: 35),
                      backgroundColor: Color(0xffd41217),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      currentIndexs: 1,
                                      Qr: widget.Qr,
                                    )));
                      }),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
