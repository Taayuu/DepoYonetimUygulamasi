// ignore_for_file: non_constant_identifier_names, empty_catches
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ihhdepom/core/service/firebaseKisayol.dart';
import 'package:ihhdepom/scan_qr_add.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'core/service/renk.dart';

class AddMaterialsPage extends StatefulWidget {
  const AddMaterialsPage(
      {Key? key,
      required this.Qr,
      required this.malzemeAdi,
      required this.malzemeSinifi,
      required this.malzemeRafi,
      required this.malzemeEkleGuncelleButtonText,
      required this.malzemeStok,
      required this.malzemeImage,
      required this.ID})
      : super(key: key);
  final String Qr;
  final String malzemeAdi;
  final String malzemeSinifi;
  final String malzemeRafi;
  final String malzemeImage;
  final String ID;
  final int malzemeStok;
  final String malzemeEkleGuncelleButtonText;
  @override
  State<AddMaterialsPage> createState() => _AddMaterialsPageState();
}

class _AddMaterialsPageState extends State<AddMaterialsPage> {
  TextEditingController materialNameController = TextEditingController();
  TextEditingController materialClassController = TextEditingController();
  TextEditingController materialDepartmentController = TextEditingController();
  TextEditingController materialQrController = TextEditingController();
  TextEditingController materialImageController = TextEditingController();
  var materialStockController = TextEditingController(text: "12345678");
  var maskFormatter = MaskTextInputFormatter(
      mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
  @override
  Widget build(BuildContext context) {
    List keyword = [];
    List bosListe = ["Depo"];
    Map<String, dynamic> materialsDataGuncelle;
    Map<String, dynamic> materialsDataEkle;
    materialStockController.value = maskFormatter.updateMask(mask: "###");
    materialQrController.text = widget.Qr;
    materialClassController.text = widget.malzemeSinifi;
    materialDepartmentController.text = widget.malzemeRafi;
    materialNameController.text = widget.malzemeAdi;
    materialStockController.text = widget.malzemeStok.toString();
    materialImageController.text = widget.malzemeImage;
    if (materialImageController.text ==
        "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjAKOCHPsSDZgL9HCwZqzRJRyAuU0jdrgJoKRbz7KSo-cXmQO02oiXrju2_QKSz8iKjY6kqcMcioQpdk_RSBagS1mD2abF4HSJrUI_lOye1CDIq56wX8RL415_KUuo2A3cYgYAXFxoKml5co8KcCg7YezMVqkqkGJmdSrjbJu_3HTUMVcqb_hvZ1MbX4Q/s1600/indir.png") {
      materialImageController.clear();
    }
    if (materialStockController.text == "0") {
      materialStockController.clear();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: anaRenk,
      appBar: AppBar(
        backgroundColor: ikinciRenk,
        title: const Text("Malzeme Ekle"),
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
                          fillColor: white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide:
                                  const BorderSide(color: black, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: black, width: 3)),
                          hintText: "Qr Kod giriniz",
                          hintStyle: const TextStyle(color: grey700),
                          suffixIcon: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ScanQrAdd()));
                            },
                            icon: const Icon(
                              Icons.qr_code_scanner_sharp,
                              color: grey600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
                                    const BorderSide(color: black, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: black, width: 3)),
                            hintText: "Malzeme Adı giriniz",
                            hintStyle: const TextStyle(color: grey700)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: materialClassController,
                        decoration: InputDecoration(
                            labelText: "Malzeme Sınıfı",
                            fillColor: white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide:
                                    const BorderSide(color: black, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: black, width: 3)),
                            hintText: "Malzeme Sınıfı giriniz",
                            hintStyle: const TextStyle(color: grey700)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: materialDepartmentController,
                        decoration: InputDecoration(
                            labelText: "Malzeme Rafı",
                            fillColor: white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide:
                                    const BorderSide(color: black, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: black, width: 3)),
                            hintText: "Malzeme Rafı giriniz",
                            hintStyle: const TextStyle(color: grey700)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: materialImageController,
                          decoration: InputDecoration(
                              labelText:
                                  "Resim URL'si (URL YOK İSE BOŞ BIRAKIN !!!)",
                              fillColor: white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide:
                                      const BorderSide(color: black, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: black, width: 3)),
                              hintText: "URL giriniz",
                              hintStyle: const TextStyle(color: grey700)),
                          style: const TextStyle(color: blue)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: materialStockController,
                          decoration: InputDecoration(
                              labelText: "Stok",
                              fillColor: white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide:
                                      const BorderSide(color: black, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: black, width: 3)),
                              hintText: "Malzeme Stoğu Giriniz",
                              hintStyle: const TextStyle(color: grey700)),
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatter]),
                      const SizedBox(height: 10),
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
                                await materialsRef
                                    .where("Malzeme Adı",
                                        isEqualTo: materialNameController.text)
                                    .get()
                                    .then((QuerySnapshot aMaterials) async {
                                  if (aMaterials.docs.isEmpty) {
                                    await materialsRef
                                        .where("Qr Kod",
                                            isEqualTo:
                                                materialQrController.text)
                                        .get()
                                        .then(
                                            (QuerySnapshot qrMaterials) async {
                                      if (qrMaterials.docs.isEmpty) {
                                        await materialsRef
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
                                                "Resim": materialImageController
                                                    .text,
                                                "ID": DateFormat(
                                                        'dd-MM-yyyy HH:mm:ss:SSSSSSS')
                                                    .format(DateTime.now())
                                                    .replaceAll("-", "")
                                                    .replaceAll(":", "")
                                                    .replaceAll(" ", "")
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
                                                    "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjAKOCHPsSDZgL9HCwZqzRJRyAuU0jdrgJoKRbz7KSo-cXmQO02oiXrju2_QKSz8iKjY6kqcMcioQpdk_RSBagS1mD2abF4HSJrUI_lOye1CDIq56wX8RL415_KUuo2A3cYgYAXFxoKml5co8KcCg7YezMVqkqkGJmdSrjbJu_3HTUMVcqb_hvZ1MbX4Q/s1600/indir.png",
                                                "ID": DateFormat(
                                                        'dd-MM-yyyy HH:mm:ss:SSSSSSS')
                                                    .format(DateTime.now())
                                                    .replaceAll("-", "")
                                                    .replaceAll(":", "")
                                                    .replaceAll(" ", "")
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
                                            await materialsRef
                                                .doc(
                                                    materialNameController.text)
                                                .update({
                                              "keyword":
                                                  FieldValue.arrayUnion(keyword)
                                            });
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            keyword.clear();
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
                                                backgroundColor: white,
                                                textColor: black,
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
                                            backgroundColor: white,
                                            textColor: black,
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
                                        backgroundColor: white,
                                        textColor: black,
                                        gravity: ToastGravity.CENTER,
                                        fontSize: 20);
                                  }
                                });
                              } else if (widget.malzemeEkleGuncelleButtonText ==
                                  "Güncelle") {
                                await urunCol
                                    .where("ID", isEqualTo: widget.ID)
                                    .where("durum", isEqualTo: 1)
                                    .get()
                                    .then((veriD) async {
                                  if (veriD.docs.isEmpty) {
                                    if (materialImageController.text != "") {
                                      materialsDataGuncelle = {
                                        "Malzeme Adı":
                                            materialNameController.text,
                                        "Malzeme Sınıfı":
                                            materialClassController.text,
                                        "Malzeme Rafı":
                                            materialDepartmentController.text,
                                        "Qr Kod": materialQrController.text,
                                        "Stok": int.parse(
                                            materialStockController.text),
                                        "Resim": materialImageController.text,
                                      };
                                    } else {
                                      materialsDataGuncelle = {
                                        "Malzeme Adı":
                                            materialNameController.text,
                                        "Malzeme Sınıfı":
                                            materialClassController.text,
                                        "Malzeme Rafı":
                                            materialDepartmentController.text,
                                        "Qr Kod": materialQrController.text,
                                        "Stok": int.parse(
                                            materialStockController.text),
                                        "Resim":
                                            "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjAKOCHPsSDZgL9HCwZqzRJRyAuU0jdrgJoKRbz7KSo-cXmQO02oiXrju2_QKSz8iKjY6kqcMcioQpdk_RSBagS1mD2abF4HSJrUI_lOye1CDIq56wX8RL415_KUuo2A3cYgYAXFxoKml5co8KcCg7YezMVqkqkGJmdSrjbJu_3HTUMVcqb_hvZ1MbX4Q/s1600/indir.png",
                                      };
                                    }

                                    await materialsRef
                                        .where("Qr Kod", isEqualTo: widget.Qr)
                                        .get()
                                        .then((QuerySnapshot qMaterials) async {
                                      for (var doc in qMaterials.docs) {
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
                                          await materialsRef
                                              .where("Qr Kod",
                                                  isEqualTo: widget.Qr)
                                              .get()
                                              .then((QuerySnapshot
                                                  qMaterials) async {
                                            for (var docd in qMaterials.docs) {
                                              materialsRef.doc(docd.id).update({
                                                "keyword": FieldValue.delete()
                                              });
                                            }
                                          });
                                          await materialsRef
                                              .where("Qr Kod",
                                                  isEqualTo: widget.Qr)
                                              .get()
                                              .then((QuerySnapshot
                                                  qMaterials) async {
                                            for (var docd in qMaterials.docs) {
                                              materialsRef.doc(docd.id).update({
                                                "keyword":
                                                    FieldValue.arrayUnion(
                                                        keyword)
                                              });
                                              keyword.clear();
                                              materialNameController.clear();
                                              materialClassController.clear();
                                              materialDepartmentController
                                                  .clear();
                                              materialQrController.clear();
                                              materialStockController.clear();
                                              materialImageController.clear();
                                            }
                                          });
                                        } catch (e) {}
                                      }
                                    });
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    Fluttertoast.showToast(
                                        msg: "Malzeme Başarıyla Güncellendi",
                                        gravity: ToastGravity.CENTER,
                                        fontSize: 20);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Ürün emanette iken değiştirilemez.",
                                        gravity: ToastGravity.CENTER,
                                        fontSize: 20);
                                  }
                                });
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Lütfen boş alanları doldurunuz",
                                  gravity: ToastGravity.CENTER,
                                  fontSize: 20);
                            }
                          },
                          color: ikinciRenk,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          child: Text(
                            'Malzemeyi ${widget.malzemeEkleGuncelleButtonText}',
                            style: const TextStyle(fontSize: 13, color: white),
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
