// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:io';

//import 'package:firebase_core/firebase_core.dart'; *firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/get_materials_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrGet extends StatefulWidget {
  const ScanQrGet({Key? key}) : super(key: key);

  @override
  State<ScanQrGet> createState() => _ScanQrGetState();
}

class _ScanQrGetState extends State<ScanQrGet> {
  final qrkey = GlobalKey(debugLabel: 'QR');
  TextEditingController barControl = TextEditingController();
  Barcode? barcode;
  QRViewController? controller;
  FirebaseAuth Auth = FirebaseAuth.instance;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void ressemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  String k_adi = "";
  String malzemeAdi = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffd41217),
          title: const Text('Qr Kod'),
        ),
        body: Stack(
          children: <Widget>[
            buildQrView(context),
            Positioned(bottom: 10, child: buildResult()),
            Positioned(top: 10, left: 150, child: buildControlButtons()),
            Positioned(bottom: 10, right: 10, child: buildOnayla()),
          ],
        ),
      ),
    );
  }

  Widget buildControlButtons() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white54),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              color: Colors.white70,
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
            ),
            IconButton(
              color: Colors.white70,
              icon: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    ressemble();
                    return const Icon(Icons.switch_camera);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
            )
          ],
        ),
      );

  Widget buildResult() => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.white70),
            child: Text(
              barControl.text = barcode != null
                  ? 'Sonuç : ${barcode!.code}'
                  : 'Qr Kodu Tarat!',
              maxLines: 3,
            ),
          ),
        ],
      );

  Widget buildOnayla() => Column(
        children: <Widget>[
          RaisedButton(
              child: const Text("Onayla"),
              onPressed: () async {
                if (barControl.text != "Qr Kodu Tarat!") {
                  await FirebaseFirestore.instance
                      .collection("Materials")
                      .where("Qr Kod", isEqualTo: barcode!.code.toString())
                      .get()
                      .then((QuerySnapshot kMaterials) async {
                    if (kMaterials.docs.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(Auth.currentUser!.email)
                          .get()
                          .then((value) {
                        k_adi = value["Kullanıcı Adı"];
                      });
                      await FirebaseFirestore.instance
                          .collection("Materials")
                          .where("Qr Kod", isEqualTo: barcode!.code.toString())
                          .get()
                          .then((QuerySnapshot qMaterials) async {
                        for (var docd in qMaterials.docs) {
                          await FirebaseFirestore.instance
                              .collection("Materials")
                              .doc(docd.id)
                              .get()
                              .then((veri) {
                            malzemeAdi = veri["Malzeme Adı"];
                          });
                        }
                      });
                      await FirebaseFirestore.instance
                          .collection("Materials")
                          .where("Qr Kod", isEqualTo: barcode!.code.toString())
                          .where("Konum", arrayContains: k_adi)
                          .get()
                          .then((QuerySnapshot gelenVeri) {
                        if (gelenVeri.docs.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GetMaterials(
                                        Qr: barcode!.code.toString(),
                                        teslimet: true,
                                        gerigel: true,
                                        teslimal: false,
                                        ID: kMaterials.docs[0]["ID"],
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GetMaterials(
                                        Qr: barcode!.code.toString(),
                                        teslimet: false,
                                        gerigel: true,
                                        teslimal: true,
                                        ID: kMaterials.docs[0]["ID"],
                                      )));
                        }
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Bu Qr Koduna Ait Ürün Bulunamadı",
                          gravity: ToastGravity.CENTER,
                          fontSize: 20,
                          backgroundColor: Colors.white,
                          textColor: Colors.black);
                    }
                  });
                }
              })
        ],
      );

  void asd() {
    if (barControl.text != "Qr Kodu Tarat!") {
      FirebaseFirestore.instance
          .collection("Materials")
          .where("Qr Kod", isEqualTo: barcode!.code.toString())
          .get()
          .then((QuerySnapshot kMaterials) async {
        if (kMaterials.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(Auth.currentUser!.email)
              .get()
              .then((value) {
            k_adi = value["Kullanıcı Adı"];
          });
          await FirebaseFirestore.instance
              .collection("Materials")
              .where("Qr Kod", isEqualTo: barcode!.code.toString())
              .get()
              .then((QuerySnapshot qMaterials) async {
            for (var docd in qMaterials.docs) {
              await FirebaseFirestore.instance
                  .collection("Materials")
                  .doc(docd.id)
                  .get()
                  .then((veri) {
                malzemeAdi = veri["Malzeme Adı"];
              });
            }
          });
          await FirebaseFirestore.instance
              .collection("Materials")
              .where("Qr Kod", isEqualTo: barcode!.code.toString())
              .where("Konum", arrayContains: k_adi)
              .get()
              .then((QuerySnapshot gelenVeri) {
            if (gelenVeri.docs.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GetMaterials(
                            Qr: barcode!.code.toString(),
                            teslimet: true,
                            gerigel: true,
                            teslimal: false,
                            ID: kMaterials.docs[0]["ID"],
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GetMaterials(
                            Qr: barcode!.code.toString(),
                            teslimet: false,
                            gerigel: true,
                            teslimal: true,
                            ID: kMaterials.docs[0]["ID"],
                          )));
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: "Bu Qr Koduna Ait Ürün Bulunamadı",
              gravity: ToastGravity.CENTER,
              fontSize: 20,
              backgroundColor: Colors.white,
              textColor: Colors.black);
        }
      });
    }
  }

  Widget buildQrView(BuildContext context) => QRView(
      key: qrkey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).colorScheme.secondary,
        borderWidth: 10,
        borderLength: 20,
        borderRadius: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ));

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) => setState(() {
          this.barcode = barcode;
          asd();
        }));
  }
}
