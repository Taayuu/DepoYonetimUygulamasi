// ignore_for_file: deprecated_member_use

import 'dart:io';
//import 'package:firebase_core/firebase_core.dart'; *firebase
import 'package:flutter/material.dart';
import 'package:login/add_materials_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrAdd extends StatefulWidget {
  const ScanQrAdd({Key? key}) : super(key: key);

  @override
  State<ScanQrAdd> createState() => _ScanQrAddState();
}

class _ScanQrAddState extends State<ScanQrAdd> {
  final qrkey = GlobalKey(debugLabel: 'QR');
  TextEditingController barControl = TextEditingController();
  Barcode? barcode;
  QRViewController? controller;

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
              onPressed: () {
                if (barControl.text != "Qr Kodu Tarat!") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMaterialsPage(
                                Qr: barcode!.code.toString(),
                                malzemeAdi: '',
                                malzemeRafi: '',
                                malzemeSinifi: '',
                                malzemeEkleGuncelleButtonText: 'Ekle',
                                malzemeStok: 0,
                                malzemeImage: '',
                                ID: '',
                              )));
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
