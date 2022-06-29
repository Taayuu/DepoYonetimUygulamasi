// ignore_for_file: deprecated_member_use, unused_local_variable, prefer_typing_uninitialized_variables, duplicate_ignore, non_constant_identifier_names, unused_field

import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:login/scan_qr_get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  TextEditingController adetController = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '####-####', filter: {"#": RegExp(r'[0-9]')});

  List<String> items = [
    "Eğitim",
    "Aktivite",
    "Özel",
    "Eğitim(DAK)",
    "Eğitim(SAK)",
    "Eğitim(KAK)"
  ];
  String? value;
  FirebaseAuth Auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    adetController.value = maskFormatter.updateMask(mask: "###");
    int stok = 0;
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
Qr Kod: ${malzemeler![index]["Qr Kod"]}
Malzeme Sınıfı: ${malzemeler![index]["Malzeme Sınıfı"]}
Malzeme Rafı: ${malzemeler![index]["Malzeme Rafı"]}
Malzeme Konumu: ${malzemeler![index]["Konum"].toString().replaceAll(']', '').replaceAll('[', '')}
Stok: ${malzemeler![index]["Stok"]}''',
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: 75,
                              child: TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  controller: adetController,
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 3)),
                                      hintText: "Adet",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [maskFormatter]),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.black, width: 2)),
                              child: Flexible(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  value: value,
                                  hint: Text(" Alma Sebebi Seçiniz"),
                                  borderRadius: BorderRadius.circular(12),
                                  elevation: 10,
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                        value: items, child: Text(items));
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      value = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MaterialButton(
                            onPressed: () async {
                              if (adetController.text != null &&
                                  adetController.text != "") {
                                if (value != null && value != "") {
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
                                          [malzemeler![0]["Malzeme Adı"]]),
                                    });

                                    FirebaseFirestore.instance
                                        .collection('Users');
                                    docRef.snapshots().listen(
                                      (event) {
                                        kAdi = event.data()!["Kullanıcı Adı"];
                                      },
                                      // ignore: avoid_print
                                      onError: (error) =>
                                          print("Listen failed: $error"),
                                    );

                                    await FirebaseFirestore.instance
                                        .collection('Materials')
                                        .doc(malzemeler?[0]['Malzeme Adı'])
                                        .update({
                                      "Konum": FieldValue.arrayUnion([kAdi])
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('Materials')
                                        .doc(malzemeler?[0]['Malzeme Adı'])
                                        .update({
                                      "Stok":
                                          stok - int.parse(adetController.text)
                                    });

                                    await FirebaseFirestore.instance
                                        .collection('Deposit')
                                        .doc(Auth.currentUser!.email)
                                        .collection("Emanetlerim")
                                        .doc(Auth.currentUser!.email)
                                        .set({
                                      "Emanet Adı":
                                          "${malzemeler?[0]["Malzeme Adı"]}",
                                      "Emanet Alma Tarihi":
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(DateTime.now()),
                                      "Emanet Alan": "$kAdi"
                                    });

                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(Auth.currentUser!.email)
                                        .get()
                                        .then((gelenVeri) async {
                                      await FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(Auth.currentUser!.email)
                                          .collection("Ürün")
                                          .doc(malzemeler?[0]["Malzeme Adı"] +
                                              Auth.currentUser!.email)
                                          .set({
                                        "Emanet": {
                                          "${malzemeler?[0]["Malzeme Adı"]}": [
                                            int.parse(adetController.text)
                                          ],
                                        },
                                        "Id": Auth.currentUser!.uid,
                                        "Emanet Alma Tarihi":
                                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(DateTime.now()),
                                        "Emanet Alma Tarihi Saatsiz":
                                            DateFormat('yyyy-MM-dd')
                                                .format(DateTime.now()),
                                        "Emanet Alan": "$kAdi",
                                        "Emanet Alma Sebebi": value,
                                        "durum": 1
                                      });
                                    });

                                    Fluttertoast.showToast(
                                        msg: "Malzeme Başarıyla Teslim Alındı",
                                        gravity: ToastGravity.CENTER,
                                        fontSize: 20);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const GetMaterials(
                                                    Qr: "",
                                                    teslimal: false,
                                                    teslimet: false,
                                                    gerigel: true)));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Bu malzeme için yeterli stok yok",
                                        gravity: ToastGravity.CENTER,
                                        fontSize: 20);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Alma Sebebi Seçiniz",
                                      gravity: ToastGravity.CENTER,
                                      fontSize: 20);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Adet Seçiniz",
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 20);
                              }
                            },
                            color: const Color(0xffd41217),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25),
                            child: const Text(
                              'Malzemeyi Teslim Al',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
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
                          .update({
                        "Konum": FieldValue.arrayRemove([kAdi])
                      });

                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(Auth.currentUser!.email)
                          .collection("Ürün")
                          .doc(
                              "${malzemeler?[0]['Malzeme Adı']}${Auth.currentUser!.email}")
                          .get()
                          .then((value) async {
                        await FirebaseFirestore.instance
                            .collection('Materials')
                            .doc(malzemeler?[0]['Malzeme Adı'])
                            .update({
                          "Stok": stok +
                              int.parse(value[
                                      "Emanet.${malzemeler?[0]['Malzeme Adı']}"]
                                  .toString()
                                  .replaceAll('[', '')
                                  .replaceAll(']', ''))
                        });
                      });

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

                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(Auth.currentUser!.email)
                          .get()
                          .then((value) async {
                        await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(Auth.currentUser!.email)
                            .collection("Ürün")
                            .doc(malzemeler?[0]["Malzeme Adı"] +
                                Auth.currentUser!.email)
                            .update({
                          //"Emanet": {
                          //  "${malzemeler?[0]["Malzeme Adı"]}": [6],
                          //},
                          "Id": Auth.currentUser!.uid,
                          "Teslim Tarihi": DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(DateTime.now()),
                          "Emanet Alan": "$kAdi",
                          "durum": 0
                        });
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
                          msg: "Malzeme Başarıyla Teslim Edildi.",
                          gravity: ToastGravity.CENTER,
                          fontSize: 20);
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
                      heroTag: "btnGeri",
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
                heroTag: "deneme",
                child: const Icon(Icons.add, size: 35),
                backgroundColor: const Color(0xffd41217),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(Auth.currentUser!.email)
                      .collection("Ürün")
                      .doc("Çadır${Auth.currentUser!.email}")
                      .get()
                      .then((value) async {
                    Fluttertoast.showToast(
                        msg:
                            "${int.parse(value["Emanet.Çadır"].toString().replaceAll('[', '').replaceAll(']', ''))}",
                        gravity: ToastGravity.CENTER,
                        fontSize: 20);
                  });
                }),
          ],
        ),
      )),
    );
  }
}
