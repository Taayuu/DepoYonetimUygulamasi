// ignore_for_file: deprecated_member_use, unused_local_variable, prefer_typing_uninitialized_variables, duplicate_ignore, non_constant_identifier_names, unused_field

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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
    int stok = 0;
    var anan;
    var malzemeAdi;
    final docRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth.currentUser!.email);
    var kAdi;
    FirebaseFirestore.instance.collection('Users');
    docRef.snapshots().listen((event) {
      kAdi = event.data()!["Kullanıcı Adı"];
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
      backgroundColor: const Color(0xffFFEBC1),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
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
                        side: const BorderSide(color: Colors.black, width: 2)),
                    color: Colors.white,
                    elevation: 500,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScanQrGet()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: const [
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
                  return const Center(
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
                                side: const BorderSide(
                                    color: Colors.black, width: 2)),
                            color: Colors.white,
                            child: ListTile(
                              leading: ClipOval(
                                child: Image.network(
                                  "${malzemeler![index]['Resim']}",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              title: Text(
                                '${malzemeler?[index]['Malzeme Adı']}',
                                style: const TextStyle(fontSize: 19),
                              ),
                              subtitle: Text(
                                '''
Qr Kod:${malzemeler![index]["Qr Kod"]}
Malzeme Sınıfı:${malzemeler![index]["Malzeme Sınıfı"]}
Malzeme Rafı:${malzemeler![index]["Malzeme Rafı"]}
Malzeme Konumu:${malzemeler![index]["Konum"]}''',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
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
                      await FirebaseFirestore.instance
                          .collection('Materials')
                          .doc(malzemeler?[0]['Malzeme Adı'])
                          .get()
                          .then((gelenVeri) {
                        stok = gelenVeri["Stok"];
                      });

                      if (stok > 0) {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(Auth.currentUser!.email)
                            .update({
                          "Emanetler": FieldValue.arrayUnion(
                              [malzemeler![0]["Malzeme Adı"]])
                        });

                        FirebaseFirestore.instance.collection('Users');
                        docRef.snapshots().listen(
                          (event) {
                            kAdi = event.data()!["Kullanıcı Adı"];
                          },
                          // ignore: avoid_print
                          onError: (error) => print("Listen failed: $error"),
                        );

                        await FirebaseFirestore.instance
                            .collection('Materials')
                            .doc(malzemeler?[0]['Malzeme Adı'])
                            .update({"Konum": kAdi});

                        await FirebaseFirestore.instance
                            .collection('Materials')
                            .doc(malzemeler?[0]['Malzeme Adı'])
                            .update({"Stok": stok - 1});

                        await FirebaseFirestore.instance
                            .collection('Deposit')
                            .doc(Auth.currentUser!.email)
                            .collection("Emanetlerim")
                            .doc(Auth.currentUser!.email)
                            .set({
                          "Emanet Adı": "${malzemeler?[0]["Malzeme Adı"]}",
                          "Emanet Alma Tarihi":
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(DateTime.now()),
                          "Emanet Alan": "$kAdi"
                        });
                        Fluttertoast.showToast(
                            msg: "Malzeme Başarıyla Teslim Alındı.");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GetMaterials(
                                    Qr: "",
                                    teslimal: false,
                                    teslimet: false,
                                    gerigel: true)));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Bu malzeme için yeterli stok yok.");
                      }
                    },
                    color: const Color(0xffd41217),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    child: const Text(
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
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('Materials')
                          .doc(malzemeler?[0]['Malzeme Adı'])
                          .get()
                          .then((gelenVeri) {
                        stok = gelenVeri["Stok"];
                      });

                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(Auth.currentUser!.email)
                          .update({
                        "Emanetler": FieldValue.arrayRemove(
                            [malzemeler?[0]["Malzeme Adı"]])
                      });

                      await FirebaseFirestore.instance
                          .collection('Materials')
                          .doc(malzemeler?[0]['Malzeme Adı'])
                          .update({"Konum": "Depo"});

                      await FirebaseFirestore.instance
                          .collection('Materials')
                          .doc(malzemeler?[0]['Malzeme Adı'])
                          .update({"Stok": stok + 1});

                      await FirebaseFirestore.instance
                          .collection('Deposit')
                          .doc(Auth.currentUser!.email)
                          .collection("Emanetlerim")
                          .doc(Auth.currentUser!.email)
                          .update({
                        "Teslim Tarihi": DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(DateTime.now()),
                      });
                      depRef.snapshots().listen((event) {
                        malzemeAdi = event.data()!["Emanet Adı"];
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GetMaterials(
                                  Qr: "",
                                  teslimal: false,
                                  teslimet: false,
                                  gerigel: true)));
                      Fluttertoast.showToast(
                          msg: "Malzeme Başarıyla Teslim Edildi.");
                    },
                    color: const Color(0xffd41217),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    child: const Text(
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
                      child: const Icon(Icons.arrow_back, size: 35),
                      backgroundColor: const Color(0xffd41217),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      currentIndexs: 1,
                                      Qr: "",
                                    )));
                      }),
                ),
              ),
            ),
            FloatingActionButton(
                child: const Icon(Icons.add, size: 35),
                backgroundColor: const Color(0xffd41217),
                onPressed: () async {
                  Map<String, int> data = {"Çekiç": 23, "Kalem": 5};
                  await FirebaseFirestore.instance
                      .collection("Deneme")
                      .doc("deneme")
                      .collection(Auth.currentUser!.uid)
                      .add(data);
                }),
          ],
        ),
      )),
    );
  }
}
