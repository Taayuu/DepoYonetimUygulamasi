// ignore_for_file: deprecated_member_use, unused_local_variable, prefer_typing_uninitialized_variables, duplicate_ignore, non_constant_identifier_names, unused_field, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:login/core/service/google_signin.dart';
import 'package:login/scan_qr_get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'home_page.dart';

class GetMaterials extends StatefulWidget {
  const GetMaterials({
    Key? key,
    required this.Qr,
    required this.teslimal,
    required this.teslimet,
    required this.gerigel,
    required this.ID,
  }) : super(key: key);
  final String Qr;
  final String ID;
  final bool teslimal;
  final bool teslimet;
  final bool gerigel;

  @override
  State<GetMaterials> createState() => _GetMaterialsState();
}

var malzemeMail;
var malzemeStokMail;
var malzemeSebepMail;
var adminMail1;
var adminMail2;
var adminMail3;
var adminMail4;
var adminMail5;

class _GetMaterialsState extends State<GetMaterials> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController adetController = TextEditingController();
  var maskFormatter = MaskTextInputFormatter(
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

    FirebaseFirestore.instance
        .collection("AppControl")
        .doc("AdminMail")
        .get()
        .then((valueMail) {
      adminMail1 = valueMail.data()!["Mail1"];
      adminMail2 = valueMail.data()!["Mail2"];
      adminMail3 = valueMail.data()!["Mail3"];
      adminMail4 = valueMail.data()!["Mail4"];
      adminMail5 = valueMail.data()!["Mail5"];
    });

    Query qmaterials = FirebaseFirestore.instance
        .collection("Materials")
        .where("Qr Kod", isEqualTo: widget.Qr);

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
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 3)),
                                      hintText: "Adet",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [maskFormatter]),
                            ),
                          ),
                          const SizedBox(
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
                                  hint: const Text(" Alma Sebebi Seçiniz"),
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
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: MaterialButton(
                            onPressed: () async {
                              if (adetController.text != "") {
                                if (value != null && value != "") {
                                  await FirebaseFirestore.instance
                                      .collection("Materials")
                                      .where("Qr Kod", isEqualTo: widget.Qr)
                                      .get()
                                      .then((QuerySnapshot qMaterials) async {
                                    for (var docd in qMaterials.docs) {
                                      await FirebaseFirestore.instance
                                          .collection('Materials')
                                          .doc(docd.id)
                                          .get()
                                          .then((gelenVeri) {
                                        stok = gelenVeri["Stok"];
                                        if (stok >=
                                            int.parse(adetController.text)) {
                                          FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(Auth.currentUser!.email)
                                              .update({
                                            "Emanetler": FieldValue.arrayUnion([
                                              malzemeler![0]["Malzeme Adı"]
                                            ]),
                                          });

                                          FirebaseFirestore.instance
                                              .collection('Users');
                                          docRef.snapshots().listen(
                                            (event) {
                                              kAdi = event
                                                  .data()!["Kullanıcı Adı"];
                                            },
                                            // ignore: avoid_print
                                            onError: (error) =>
                                                print("Listen failed: $error"),
                                          );
                                          FirebaseFirestore.instance
                                              .collection("Materials")
                                              .where("Qr Kod",
                                                  isEqualTo: widget.Qr)
                                              .get()
                                              .then((QuerySnapshot
                                                  qMaterials) async {
                                            for (var docd in qMaterials.docs) {
                                              await FirebaseFirestore.instance
                                                  .collection('Materials')
                                                  .doc(docd.id)
                                                  .update({
                                                "Konum": FieldValue.arrayUnion(
                                                    [kAdi])
                                              });
                                            }
                                          });

                                          FirebaseFirestore.instance
                                              .collection("Materials")
                                              .where("Qr Kod",
                                                  isEqualTo: widget.Qr)
                                              .get()
                                              .then((QuerySnapshot
                                                  qMaterials) async {
                                            for (var docd in qMaterials.docs) {
                                              await FirebaseFirestore.instance
                                                  .collection('Materials')
                                                  .doc(docd.id)
                                                  .update({
                                                "Stok": stok -
                                                    int.parse(
                                                        adetController.text)
                                              });
                                            }
                                          });

                                          FirebaseFirestore.instance
                                              .collection("Materials")
                                              .where("Qr Kod",
                                                  isEqualTo: widget.Qr)
                                              .get()
                                              .then((QuerySnapshot
                                                  qMaterials) async {
                                            for (var docdf in qMaterials.docs) {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(Auth.currentUser!.email)
                                                  .get()
                                                  .then((gelenVeri) async {
                                                await FirebaseFirestore.instance
                                                    .collection("Users")
                                                    .doc(
                                                        Auth.currentUser!.email)
                                                    .collection("Ürün")
                                                    .add({
                                                  "Emanet": {
                                                    "${malzemeler?[0]["Malzeme Adı"]}":
                                                        [
                                                      int.parse(
                                                          adetController.text)
                                                    ],
                                                  },
                                                  "Id": Auth.currentUser!.uid,
                                                  "Emanet Alma Tarihi": DateFormat(
                                                          'dd-MM-yyyy HH:mm:ss')
                                                      .format(DateTime.now()),
                                                  "Emanet Alma Tarihi Saatsiz":
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(
                                                              DateTime.now()),
                                                  "Emanet Alan": "$kAdi",
                                                  "Emanet Alma Sebebi": value,
                                                  "durum": 1,
                                                  "Eksik": 0,
                                                  "İlk Alınan": int.parse(
                                                      adetController.text),
                                                  "ID": malzemeler?[0]["ID"],
                                                  "Qr Kod": malzemeler?[0]
                                                      ["Qr Kod"],
                                                });
                                              });
                                            }
                                          });

                                          malzemeSebepMail = value.toString();
                                          malzemeMail = malzemeler?[0]
                                                  ["Malzeme Adı"]
                                              .toString();
                                          malzemeStokMail =
                                              int.parse(adetController.text)
                                                  .toString();

                                          SendAlEmail();

                                          Fluttertoast.showToast(
                                              msg:
                                                  "Malzeme Başarıyla Teslim Alındı",
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
                                                        gerigel: true,
                                                        ID: '',
                                                      )));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Bu malzeme için yeterli stok yok",
                                              gravity: ToastGravity.CENTER,
                                              fontSize: 20);
                                        }
                                      });
                                    }
                                  });
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
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 3)),
                                      hintText: "Adet",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700])),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [maskFormatter]),
                            ),
                          ),
                        ],
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (adetController.text != "") {
                            await FirebaseFirestore.instance
                                .collection("Materials")
                                .where("Qr Kod", isEqualTo: widget.Qr)
                                .get()
                                .then((QuerySnapshot qMaterials) async {
                              for (var docde in qMaterials.docs) {
                                await FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(Auth.currentUser!.email)
                                    .collection("Ürün")
                                    .where("ID", isEqualTo: widget.ID)
                                    .where("Id",
                                        isEqualTo: Auth.currentUser!.uid)
                                    .where("durum", isEqualTo: 1)
                                    .get()
                                    .then((value) async {
                                  if (int.parse(adetController.text) != 0 &&
                                      int.parse(adetController.text) > 0 &&
                                      int.parse(adetController.text) <=
                                          int.parse(value.docs[0][
                                                  "Emanet.${malzemeler?[0]['Malzeme Adı']}"]
                                              .toString()
                                              .replaceAll('[', '')
                                              .replaceAll(']', ''))) {
                                    await FirebaseFirestore.instance
                                        .collection("Materials")
                                        .where("Qr Kod", isEqualTo: widget.Qr)
                                        .get()
                                        .then((QuerySnapshot qMaterials) async {
                                      for (var docd in qMaterials.docs) {
                                        await FirebaseFirestore.instance
                                            .collection('Materials')
                                            .doc(docd.id)
                                            .get()
                                            .then((gelenVeri) {
                                          stok = gelenVeri["Stok"];
                                        });
                                      }
                                    });
                                    await FirebaseFirestore.instance
                                        .collection("Materials")
                                        .where("Qr Kod", isEqualTo: widget.Qr)
                                        .get()
                                        .then((QuerySnapshot qMaterials) async {
                                      for (var docd in qMaterials.docs) {
                                        await FirebaseFirestore.instance
                                            .collection('Materials')
                                            .doc(docd.id)
                                            .update({
                                          "Stok": stok +
                                              int.parse(adetController.text)
                                        });
                                      }
                                    });

                                    if (value.docs[0]["Eksik"] == 0) {
                                      if (int.parse(value.docs[0][
                                                      "Emanet.${malzemeler?[0]['Malzeme Adı']}"]
                                                  .toString()
                                                  .replaceAll('[', '')
                                                  .replaceAll(']', '')) -
                                              int.parse(adetController.text) >
                                          0) {
                                        await FirebaseFirestore.instance
                                            .collection("Materials")
                                            .where("Qr Kod",
                                                isEqualTo: widget.Qr)
                                            .get()
                                            .then((QuerySnapshot
                                                qMaterials) async {
                                          for (var docd in qMaterials.docs) {
                                            await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(Auth.currentUser!.email)
                                                .get()
                                                .then((gelenVeri) async {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(Auth.currentUser!.email)
                                                  .collection("Ürün")
                                                  .where("ID",
                                                      isEqualTo: widget.ID)
                                                  .where("durum", isEqualTo: 1)
                                                  .where("Id",
                                                      isEqualTo:
                                                          Auth.currentUser?.uid)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      deyta) async {
                                                for (var dave in deyta.docs) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(Auth
                                                          .currentUser!.email)
                                                      .collection("Ürün")
                                                      .doc(dave.id)
                                                      .update({
                                                    "Id": Auth.currentUser!.uid,
                                                    "Teslim Tarihi": DateFormat(
                                                            'dd-MM-yyyy HH:mm:ss')
                                                        .format(DateTime.now()),
                                                    "Emanet Alan": "$kAdi",
                                                    "Eksik": int.parse(value
                                                            .docs[0][
                                                                "Emanet.${malzemeler?[0]['Malzeme Adı']}"]
                                                            .toString()
                                                            .replaceAll('[', '')
                                                            .replaceAll(
                                                                ']', '')) -
                                                        int.parse(adetController
                                                            .text),
                                                    "durum": 1,
                                                  });
                                                }
                                              });
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(Auth.currentUser!.email)
                                                  .collection("Ürün")
                                                  .where("ID",
                                                      isEqualTo: widget.ID)
                                                  .where("durum", isEqualTo: 1)
                                                  .where("Id",
                                                      isEqualTo:
                                                          Auth.currentUser?.uid)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      deyta) async {
                                                for (var dave in deyta.docs) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(Auth
                                                          .currentUser!.email)
                                                      .collection("Ürün")
                                                      .doc(dave.id)
                                                      .get()
                                                      .then((gelen) async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Users")
                                                        .doc(Auth
                                                            .currentUser!.email)
                                                        .collection("Ürün")
                                                        .doc(dave.id)
                                                        .update({
                                                      "Emanet": {
                                                        "${malzemeler?[0]["Malzeme Adı"]}":
                                                            [gelen["Eksik"]],
                                                      },
                                                    });
                                                  });
                                                }
                                              });
                                            });
                                          }
                                        });
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection("Materials")
                                            .where("Qr Kod",
                                                isEqualTo: widget.Qr)
                                            .get()
                                            .then((QuerySnapshot
                                                qMaterials) async {
                                          for (var docd in qMaterials.docs) {
                                            await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(Auth.currentUser!.email)
                                                .get()
                                                .then((gelenVeri) async {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(Auth.currentUser!.email)
                                                  .collection("Ürün")
                                                  .where("ID",
                                                      isEqualTo: widget.ID)
                                                  .where("durum", isEqualTo: 1)
                                                  .where("Id",
                                                      isEqualTo:
                                                          Auth.currentUser?.uid)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      deyta) async {
                                                for (var dave in deyta.docs) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(Auth
                                                          .currentUser!.email)
                                                      .collection("Ürün")
                                                      .doc(dave.id)
                                                      .update({
                                                    "Id": Auth.currentUser!.uid,
                                                    "Teslim Tarihi": DateFormat(
                                                            'dd-MM-yyyy HH:mm:ss')
                                                        .format(DateTime.now()),
                                                    "Emanet Alan": "$kAdi",
                                                    "Eksik": int.parse(value
                                                            .docs[0][
                                                                "Emanet.${malzemeler?[0]['Malzeme Adı']}"]
                                                            .toString()
                                                            .replaceAll('[', '')
                                                            .replaceAll(
                                                                ']', '')) -
                                                        int.parse(adetController
                                                            .text),
                                                    "durum": 0,
                                                    "Emanet": {
                                                      "${malzemeler?[0]["Malzeme Adı"]}":
                                                          [
                                                        value.docs[0]
                                                            ["İlk Alınan"]
                                                      ],
                                                    },
                                                  });
                                                }

                                                await FirebaseFirestore.instance
                                                    .collection('Users')
                                                    .doc(
                                                        Auth.currentUser!.email)
                                                    .update({
                                                  "Emanetler":
                                                      FieldValue.arrayRemove([
                                                    malzemeler?[0]
                                                        ["Malzeme Adı"]
                                                  ])
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection("Materials")
                                                    .where("Qr Kod",
                                                        isEqualTo: widget.Qr)
                                                    .get()
                                                    .then((QuerySnapshot
                                                        qMaterials) async {
                                                  for (var docdd
                                                      in qMaterials.docs) {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Materials')
                                                        .doc(docdd.id)
                                                        .update({
                                                      "Konum": FieldValue
                                                          .arrayRemove([kAdi])
                                                    });
                                                  }
                                                });
                                              });
                                            });
                                          }
                                        });
                                      }
                                    } else {
                                      if (value.docs[0]["Eksik"] -
                                              int.parse(adetController.text) >
                                          0) {
                                        await FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(Auth.currentUser!.email)
                                            .get()
                                            .then((gelenVeri) async {
                                          await FirebaseFirestore.instance
                                              .collection("Materials")
                                              .where("Qr Kod",
                                                  isEqualTo: widget.Qr)
                                              .get()
                                              .then((QuerySnapshot
                                                  qMaterials) async {
                                            for (var docd in qMaterials.docs) {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(Auth.currentUser!.email)
                                                  .collection("Ürün")
                                                  .where("ID",
                                                      isEqualTo: widget.ID)
                                                  .where("durum", isEqualTo: 1)
                                                  .where("Id",
                                                      isEqualTo:
                                                          Auth.currentUser?.uid)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      deyta) async {
                                                for (var dave in deyta.docs) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(Auth
                                                          .currentUser!.email)
                                                      .collection("Ürün")
                                                      .doc(dave.id)
                                                      .update({
                                                    "Id": Auth.currentUser!.uid,
                                                    "Teslim Tarihi": DateFormat(
                                                            'dd-MM-yyyy HH:mm:ss')
                                                        .format(DateTime.now()),
                                                    "Emanet Alan": "$kAdi",
                                                    "Eksik": value.docs[0]
                                                            ["Eksik"] -
                                                        int.parse(adetController
                                                            .text),
                                                    "durum": 1,
                                                  });
                                                }
                                              });
                                            }
                                          });

                                          await FirebaseFirestore.instance
                                              .collection("Materials")
                                              .where("Qr Kod",
                                                  isEqualTo: widget.Qr)
                                              .get()
                                              .then((QuerySnapshot
                                                  qMaterials) async {
                                            for (var docd in qMaterials.docs) {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(Auth.currentUser!.email)
                                                  .collection("Ürün")
                                                  .where("ID",
                                                      isEqualTo: widget.ID)
                                                  .where("durum", isEqualTo: 1)
                                                  .where("Id",
                                                      isEqualTo:
                                                          Auth.currentUser?.uid)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      deyta) async {
                                                for (var dave in deyta.docs) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(Auth
                                                          .currentUser!.email)
                                                      .collection("Ürün")
                                                      .doc(dave.id)
                                                      .update({
                                                    "Emanet": {
                                                      "${malzemeler?[0]["Malzeme Adı"]}":
                                                          [dave["Eksik"]],
                                                    },
                                                  });
                                                }
                                              });
                                            }
                                          });
                                        });
                                      } else {
                                        await FirebaseFirestore.instance
                                            .collection("Materials")
                                            .where("Qr Kod",
                                                isEqualTo: widget.Qr)
                                            .get()
                                            .then((QuerySnapshot
                                                qMaterials) async {
                                          for (var docd in qMaterials.docs) {
                                            await FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(Auth.currentUser!.email)
                                                .get()
                                                .then((gelenVeri) async {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .doc(Auth.currentUser!.email)
                                                  .collection("Ürün")
                                                  .where("ID",
                                                      isEqualTo: widget.ID)
                                                  .where("Id",
                                                      isEqualTo:
                                                          Auth.currentUser?.uid)
                                                  .where("durum", isEqualTo: 1)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      deyta) async {
                                                for (var dave in deyta.docs) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(Auth
                                                          .currentUser!.email)
                                                      .collection("Ürün")
                                                      .doc(dave.id)
                                                      .update({
                                                    "Id": Auth.currentUser!.uid,
                                                    "Teslim Tarihi": DateFormat(
                                                            'dd-MM-yyyy HH:mm:ss')
                                                        .format(DateTime.now()),
                                                    "Emanet Alan": "$kAdi",
                                                    "Eksik": value.docs[0]
                                                            ["Eksik"] -
                                                        int.parse(adetController
                                                            .text),
                                                    "durum": 0,
                                                    "Emanet": {
                                                      "${malzemeler?[0]["Malzeme Adı"]}":
                                                          [
                                                        value.docs[0]
                                                            ["İlk Alınan"]
                                                      ],
                                                    },
                                                  });
                                                }
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(Auth.currentUser!.email)
                                                  .update({
                                                "Emanetler":
                                                    FieldValue.arrayRemove([
                                                  malzemeler?[0]["Malzeme Adı"]
                                                ])
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection("Materials")
                                                  .where("Qr Kod",
                                                      isEqualTo: widget.Qr)
                                                  .get()
                                                  .then((QuerySnapshot
                                                      qMaterials) async {
                                                for (var docdd
                                                    in qMaterials.docs) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Materials')
                                                      .doc(docdd.id)
                                                      .update({
                                                    "Konum":
                                                        FieldValue.arrayRemove(
                                                            [kAdi])
                                                  });
                                                }
                                              });
                                            });
                                          }
                                        });
                                      }
                                    }

                                    malzemeMail = malzemeler?[0]["Malzeme Adı"]
                                        .toString();
                                    malzemeStokMail =
                                        int.parse(adetController.text)
                                            .toString();

                                    SendTeslimEmail();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const GetMaterials(
                                                  Qr: "",
                                                  teslimal: false,
                                                  teslimet: false,
                                                  gerigel: true,
                                                  ID: '',
                                                )));
                                    Fluttertoast.showToast(
                                        msg: "Malzeme Başarıyla Teslim Edildi.",
                                        gravity: ToastGravity.CENTER,
                                        fontSize: 20);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Elinizdeki malzeme miktarından büyük adet girilemez");
                                  }
                                });
                              }
                            });
                          } else {
                            Fluttertoast.showToast(msg: "Lütfen adet giriniz");
                          }
                        },
                        color: const Color(0xffd41217),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 25),
                        child: const Text(
                          'Malzemeyi Teslim Et',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ],
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
                                      ID: '',
                                    )));
                      }),
                ),
              ),
            ),
            /*FloatingActionButton(
                heroTag: "deneme",
                child: const Icon(Icons.add, size: 35),
                backgroundColor: const Color(0xffd41217),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(Auth.currentUser!.email)
                      .collection("Ürün")
                      .doc("0PsFwPPZDgoOz04oTOeF")
                      .delete();
                }),*/
          ],
        ),
      )),
    );
  }
}

Future SendAlEmail() async {
  GoogleAuthApi.signOut();
  FirebaseAuth Auth = FirebaseAuth.instance;
  final docRef = FirebaseFirestore.instance
      .collection("Users")
      .doc(Auth.currentUser!.email);
  var kAdi;
  FirebaseFirestore.instance.collection('Users');
  docRef.snapshots().listen((event) {
    kAdi = event.data()!["Kullanıcı Adı"];
  });

  final user = await GoogleAuthApi.signIn();

  if (user == null) return;

  final email = user.email;
  final auth = await user.authentication;
  final token = auth.accessToken!;

  print('Authenticated: $email');

  final smtpServer = gmailSaslXoauth2(email, token);
  final message = Message()
    ..from = Address(email, 'İHH Depo - $kAdi')
    ..recipients = [
      Auth.currentUser!.email,
      adminMail1,
      adminMail2,
      adminMail3,
      adminMail4,
      adminMail5
    ]
    ..subject = 'Emanet Hareket Bildirisi'
    ..text =
        '''$kAdi [$malzemeMail] malzemesinden  $malzemeSebepMail için [$malzemeStokMail] adet aldı. 
        Tarih:${DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now())}''';

  try {
    await send(message, smtpServer);
    Fluttertoast.showToast(msg: "Mail Gönderildi");
  } on MailerException catch (e) {
    print(e);
  }
}

Future SendTeslimEmail() async {
  GoogleAuthApi.signOut();
  FirebaseAuth Auth = FirebaseAuth.instance;
  final docRef = FirebaseFirestore.instance
      .collection("Users")
      .doc(Auth.currentUser!.email);
  var kAdi;
  FirebaseFirestore.instance.collection('Users');
  docRef.snapshots().listen((event) {
    kAdi = event.data()!["Kullanıcı Adı"];
  });

  final user = await GoogleAuthApi.signIn();

  if (user == null) return;

  final email = user.email;
  final auth = await user.authentication;
  final token = auth.accessToken!;

  print('Authenticated: $email');

  final smtpServer = gmailSaslXoauth2(email, token);
  final message = Message()
    ..from = Address(email, 'İHH Depo - $kAdi')
    ..recipients = [
      Auth.currentUser!.email,
      adminMail1,
      adminMail2,
      adminMail3,
      adminMail4,
      adminMail5
    ]
    ..subject = 'Emanet Hareket Bildirisi'
    ..text =
        '''$kAdi [$malzemeMail] malzemesinden [$malzemeStokMail] adet teslim etti. 
        Tarih:${DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now())}''';

  try {
    await send(message, smtpServer);
    Fluttertoast.showToast(msg: "Mail Gönderildi");
  } on MailerException catch (e) {
    print(e);
  }
}
