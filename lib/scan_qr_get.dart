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
          backgroundColor: Color(0xffd41217),
          title: Text('Qr Kod'),
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
        padding: EdgeInsets.symmetric(horizontal: 16),
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
                    return Icon(Icons.switch_camera);
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
            padding: EdgeInsets.all(12),
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
              child: Text("Onayla"),
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
                          .doc(kMaterials.docs[0]["Malzeme Adı"])
                          .get()
                          .then((veri) {
                        malzemeAdi = veri["Malzeme Adı"];
                      });
                      await FirebaseFirestore.instance
                          .collection("Materials")
                          .where("Malzeme Adı", isEqualTo: malzemeAdi)
                          .where("Konum", isEqualTo: k_adi)
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
                                      teslimal: true)));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GetMaterials(
                                      Qr: barcode!.code.toString(),
                                      teslimet: false,
                                      gerigel: true,
                                      teslimal: true)));
                        }
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Bu Qr Koduna Ait Ürün Bulunamadı",
                          backgroundColor: Colors.white,
                          textColor: Colors.black);
                    }
                  });
                }
              })
        ],
      );

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
    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
  }
}
