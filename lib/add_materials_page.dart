import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/scan_qr_add.dart';

class AddMaterialsPage extends StatefulWidget {
  AddMaterialsPage(
      {Key? key,
      required this.Qr,
      required this.malzemeAdi,
      required this.malzemeSinifi,
      required this.malzemeRafi,
      required this.malzemeEkleGuncelleButtonText,
      required this.malzemeKonum})
      : super(key: key);
  final String Qr;
  final String malzemeAdi;
  final String malzemeSinifi;
  final String malzemeRafi;
  final String malzemeKonum;
  final String malzemeEkleGuncelleButtonText;
  @override
  State<AddMaterialsPage> createState() => _AddMaterialsPageState();
}

class _AddMaterialsPageState extends State<AddMaterialsPage> {
  late String indirmeBaglantisi;
  late File yuklenecekDosya;

  kameradanYukle() async {
    var alinanResim = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      yuklenecekDosya = File(alinanResim!.path);
    });
    Reference resimRef =
        FirebaseStorage.instance.ref().child("malzemeresmi").child("rsm.png");

    UploadTask yuklemeGorevi = resimRef.putFile(yuklenecekDosya);
    String url = await yuklemeGorevi.snapshot.ref.getDownloadURL();
    setState(() {
      indirmeBaglantisi = url;
    });
  }

  final _firestore = FirebaseFirestore.instance;
  TextEditingController materialNameController = TextEditingController();
  TextEditingController materialClassController = TextEditingController();
  TextEditingController materialDepartmentController = TextEditingController();
  TextEditingController materialQrController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CollectionReference materialsRef = _firestore.collection('Materials');
    materialQrController.text = widget.Qr;
    materialClassController.text = widget.malzemeSinifi;
    materialDepartmentController.text = widget.malzemeRafi;
    materialNameController.text = widget.malzemeAdi;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffFFEBC1),
      appBar: AppBar(
        backgroundColor: Color(0xffd41217),
        title: Text("Malzeme Ekle"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: materialQrController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2)),
                          hintText: "Qr Kod giriniz",
                          hintStyle: TextStyle(color: Colors.grey[700]),
                          suffixIcon: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanQrAdd()));
                            },
                            icon: Icon(
                              Icons.qr_code_scanner_sharp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: materialNameController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            hintText: "Malzeme Adı giriniz",
                            hintStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: materialClassController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            hintText: "Malzeme Sınıfı giriniz",
                            hintStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: materialDepartmentController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            hintText: "Malzeme Rafı giriniz",
                            hintStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      Row(
                        children: [
                          Text(
                            "Fotoğraf Ekle : ",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 225),
                            child: IconButton(
                              onPressed: () async {
                                await kameradanYukle();
                              },
                              icon: Icon(
                                Icons.photo_camera,
                                size: 30,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: MaterialButton(
                          onPressed: () async {
                            Map<String, dynamic> materialsDataEkle = {
                              "Malzeme Adı": materialNameController.text,
                              "Malzeme Sınıfı": materialClassController.text,
                              "Malzeme Rafı": materialDepartmentController.text,
                              "Qr Kod": materialQrController.text,
                              "Konum": "Depo",
                            };
                            Map<String, dynamic> materialsDataGuncelle = {
                              "Malzeme Adı": materialNameController.text,
                              "Malzeme Sınıfı": materialClassController.text,
                              "Malzeme Rafı": materialDepartmentController.text,
                              "Qr Kod": materialQrController.text,
                              "Konum": "Depo",
                            };
                            if (widget.malzemeEkleGuncelleButtonText ==
                                "Ekle") {
                              await materialsRef
                                  .doc(materialNameController.text)
                                  .set(materialsDataEkle);
                              Fluttertoast.showToast(
                                  msg: "Malzeme Başarıyla Eklendi.");
                            } else if (widget.malzemeEkleGuncelleButtonText ==
                                "Güncelle") {
                              FirebaseFirestore.instance
                                  .collection("Materials")
                                  .where("Malzeme Adı", isEqualTo: "halatda")
                                  .get()
                                  .then((QuerySnapshot qMaterials) {
                                materialsRef
                                    .doc(qMaterials.docs.toString())
                                    .update(materialsDataGuncelle);
                              });

                              Fluttertoast.showToast(
                                  msg: "Malzeme Başarıyla Güncellendi.");
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                            materialNameController.clear();
                            materialClassController.clear();
                            materialDepartmentController.clear();
                            materialQrController.clear();
                          },
                          color: Color(0xffd41217),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          child: Text(
                            'Malzemeyi ${widget.malzemeEkleGuncelleButtonText}',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
