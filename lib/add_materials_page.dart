import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/scan_qr_add.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddMaterialsPage extends StatefulWidget {
  AddMaterialsPage(
      {Key? key,
      required this.Qr,
      required this.malzemeAdi,
      required this.malzemeSinifi,
      required this.malzemeRafi,
      required this.malzemeEkleGuncelleButtonText,
      required this.malzemeStok,
      required this.malzemeImage})
      : super(key: key);
  final String Qr;
  final String malzemeAdi;
  final String malzemeSinifi;
  final String malzemeRafi;
  final String malzemeImage;
  final int malzemeStok;
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
  TextEditingController materialImageController = TextEditingController();
  var materialStockController = TextEditingController(text: "12345678");
  var maskFormatter = new MaskTextInputFormatter(
      mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
  // -> "12-34-56-78"
  @override
  Widget build(BuildContext context) {
    List keyword = [];
    List bosListe = ["Depo"];
    Map<String, dynamic> materialsDataGuncelle;
    Map<String, dynamic> materialsDataEkle;
    materialStockController.value = maskFormatter.updateMask(mask: "###");
    CollectionReference materialsRef = _firestore.collection('Materials');
    materialQrController.text = widget.Qr;
    materialClassController.text = widget.malzemeSinifi;
    materialDepartmentController.text = widget.malzemeRafi;
    materialNameController.text = widget.malzemeAdi;
    materialStockController.text = widget.malzemeStok.toString();
    materialImageController.text = widget.malzemeImage;
    if (materialImageController.text ==
        "https://scontent.fesb10-3.fna.fbcdn.net/v/t1.6435-9/62213204_3238487636165202_1232018786266120192_n.png?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=uI8gG8nVd3UAX8bCQ2O&_nc_ht=scontent.fesb10-3.fna&oh=00_AT_TDBmG4DsowdwCwLUwKX78pOWpXOWq0ICeQlXMWNYnAA&oe=62C0A333") {
      materialImageController.clear();
    }
    if (materialStockController.text == "0") {
      materialStockController.clear();
    }
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
                        textCapitalization: TextCapitalization.words,
                        controller: materialQrController,
                        decoration: InputDecoration(
                          labelText: "Qr Kod",
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3)),
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
                        textCapitalization: TextCapitalization.words,
                        controller: materialNameController,
                        decoration: InputDecoration(
                            labelText: "Malzeme Adı",
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 3)),
                            hintText: "Malzeme Adı giriniz",
                            hintStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: materialClassController,
                        decoration: InputDecoration(
                            labelText: "Malzeme Sınıfı",
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 3)),
                            hintText: "Malzeme Sınıfı giriniz",
                            hintStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: materialDepartmentController,
                        decoration: InputDecoration(
                            labelText: "Malzeme Rafı",
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 3)),
                            hintText: "Malzeme Rafı giriniz",
                            hintStyle: TextStyle(color: Colors.grey[700])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: materialImageController,
                          decoration: InputDecoration(
                              labelText: "Malzeme Resmi",
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 3)),
                              hintText: "URL giriniz",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                          style: TextStyle(color: Colors.blue)),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: materialStockController,
                          decoration: InputDecoration(
                              labelText: "Stok",
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 3)),
                              hintText: "Malzeme Stoğu Giriniz",
                              hintStyle: TextStyle(color: Colors.grey[700])),
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatter]),
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: MaterialButton(
                          onPressed: () async {
                            if (materialClassController.text != "" &&
                                materialDepartmentController.text != "" &&
                                materialNameController.text != "" &&
                                materialQrController.text != "" &&
                                materialStockController.text != "") {
                              if (widget.malzemeEkleGuncelleButtonText ==
                                  "Ekle") {
                                FirebaseFirestore.instance
                                    .collection("Materials")
                                    .where("Malzeme Adı",
                                        isEqualTo: materialNameController.text)
                                    .get()
                                    .then((QuerySnapshot aMaterials) async {
                                  if (aMaterials.docs.isEmpty) {
                                    FirebaseFirestore.instance
                                        .collection("Materials")
                                        .where("Qr Kod",
                                            isEqualTo:
                                                materialQrController.text)
                                        .get()
                                        .then(
                                            (QuerySnapshot qrMaterials) async {
                                      if (qrMaterials.docs.isEmpty) {
                                        FirebaseFirestore.instance
                                            .collection("Materials")
                                            .where("Malzeme Rafı",
                                                isEqualTo:
                                                    materialDepartmentController
                                                        .text)
                                            .get()
                                            .then((QuerySnapshot
                                                rMaterials) async {
                                          if (rMaterials.docs.isEmpty) {
                                            if (materialImageController.text !=
                                                "") {
                                              materialsDataEkle = {
                                                "Malzeme Adı":
                                                    materialNameController.text,
                                                "Malzeme Sınıfı":
                                                    materialClassController
                                                        .text,
                                                "Malzeme Rafı":
                                                    materialDepartmentController
                                                        .text,
                                                "Qr Kod":
                                                    materialQrController.text,
                                                "Stok": int.parse(
                                                    materialStockController
                                                        .text),
                                                "Konum": FieldValue.arrayUnion(
                                                    bosListe),
                                                "Resim":
                                                    materialImageController.text
                                              };
                                            } else {
                                              materialsDataEkle = {
                                                "Malzeme Adı":
                                                    materialNameController.text,
                                                "Malzeme Sınıfı":
                                                    materialClassController
                                                        .text,
                                                "Malzeme Rafı":
                                                    materialDepartmentController
                                                        .text,
                                                "Qr Kod":
                                                    materialQrController.text,
                                                "Stok": int.parse(
                                                    materialStockController
                                                        .text),
                                                "Konum": FieldValue.arrayUnion(
                                                    bosListe),
                                                "Resim":
                                                    "https://scontent.fesb10-3.fna.fbcdn.net/v/t1.6435-9/62213204_3238487636165202_1232018786266120192_n.png?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=uI8gG8nVd3UAX8bCQ2O&_nc_ht=scontent.fesb10-3.fna&oh=00_AT_TDBmG4DsowdwCwLUwKX78pOWpXOWq0ICeQlXMWNYnAA&oe=62C0A333",
                                              };
                                            }
                                            await materialsRef
                                                .doc(
                                                    materialNameController.text)
                                                .set(materialsDataEkle);
                                            try {
                                              for (var i = 1;
                                                  i <
                                                      materialNameController
                                                              .text.length +
                                                          1;
                                                  i++) {
                                                keyword.add(
                                                  materialNameController.text
                                                      .toString()
                                                      .substring(0, i),
                                                );
                                              }
                                            } catch (e) {}
                                            await FirebaseFirestore.instance
                                                .collection("Materials")
                                                .doc(
                                                    materialNameController.text)
                                                .update({
                                              "keyword":
                                                  FieldValue.arrayUnion(keyword)
                                            });
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            materialNameController.clear();
                                            materialClassController.clear();
                                            materialDepartmentController
                                                .clear();
                                            materialQrController.clear();
                                            materialStockController.clear();
                                            materialImageController.clear();
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Malzeme Başarıyla Eklendi",
                                                gravity: ToastGravity.CENTER,
                                                fontSize: 20);
                                          } else {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Bu rafta bir ürün zaten mevcut",
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                gravity: ToastGravity.CENTER,
                                                fontSize: 20);
                                          }
                                        });
                                      } else {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        Fluttertoast.showToast(
                                            msg:
                                                "Bu Qr Koda Sahip Malzeme zaten mevcut",
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            gravity: ToastGravity.CENTER,
                                            fontSize: 20);
                                      }
                                    });
                                  } else {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    Fluttertoast.showToast(
                                        msg:
                                            "Bu Ada Sahip Malzeme zaten mevcut",
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        gravity: ToastGravity.CENTER,
                                        fontSize: 20);
                                  }
                                });
                              } else if (widget.malzemeEkleGuncelleButtonText ==
                                  "Güncelle") {
                                if (materialImageController.text != "") {
                                  materialsDataGuncelle = {
                                    "Malzeme Adı": materialNameController.text,
                                    "Malzeme Sınıfı":
                                        materialClassController.text,
                                    "Malzeme Rafı":
                                        materialDepartmentController.text,
                                    "Qr Kod": materialQrController.text,
                                    "Stok":
                                        int.parse(materialStockController.text),
                                    "Resim": materialImageController.text
                                  };
                                } else {
                                  materialsDataGuncelle = {
                                    "Malzeme Adı": materialNameController.text,
                                    "Malzeme Sınıfı":
                                        materialClassController.text,
                                    "Malzeme Rafı":
                                        materialDepartmentController.text,
                                    "Qr Kod": materialQrController.text,
                                    "Stok":
                                        int.parse(materialStockController.text),
                                    "Resim":
                                        "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjAKOCHPsSDZgL9HCwZqzRJRyAuU0jdrgJoKRbz7KSo-cXmQO02oiXrju2_QKSz8iKjY6kqcMcioQpdk_RSBagS1mD2abF4HSJrUI_lOye1CDIq56wX8RL415_KUuo2A3cYgYAXFxoKml5co8KcCg7YezMVqkqkGJmdSrjbJu_3HTUMVcqb_hvZ1MbX4Q/s1600/indir.png"
                                  };
                                }
                                await FirebaseFirestore.instance
                                    .collection("Materials")
                                    .where("Qr Kod", isEqualTo: widget.Qr)
                                    .get()
                                    .then((QuerySnapshot qMaterials) async {
                                  qMaterials.docs.forEach((doc) async {
                                    materialsRef
                                        .doc(doc.id)
                                        .update(materialsDataGuncelle);
                                    try {
                                      for (var i = 1;
                                          i <
                                              materialNameController
                                                      .text.length +
                                                  1;
                                          i++) {
                                        keyword.add(
                                          materialNameController.text
                                              .toString()
                                              .substring(0, i),
                                        );
                                      }
                                    } catch (e) {}
                                    await FirebaseFirestore.instance
                                        .collection("Materials")
                                        .doc(materialNameController.text)
                                        .update({
                                      "keyword": FieldValue.arrayUnion(keyword)
                                    });
                                  });
                                });
                                FocusManager.instance.primaryFocus?.unfocus();
                                materialNameController.clear();
                                materialClassController.clear();
                                materialDepartmentController.clear();
                                materialQrController.clear();
                                materialStockController.clear();
                                materialImageController.clear();
                                Fluttertoast.showToast(
                                    msg: "Malzeme Başarıyla Güncellendi",
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 20);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Lütfen boş alanları doldurunuz",
                                  gravity: ToastGravity.CENTER,
                                  fontSize: 20);
                            }
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
