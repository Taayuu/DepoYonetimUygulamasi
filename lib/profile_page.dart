// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, non_constant_identifier_names, duplicate_ignore

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.malzeme}) : super(key: key);
  final String malzeme;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController k_adi = TextEditingController();
  TextEditingController eposta = TextEditingController();
  TextEditingController k_tarihi = TextEditingController();
  TextEditingController emanetler = TextEditingController();
  final GlobalKey enabl = GlobalKey();
  FirebaseAuth Auth = FirebaseAuth.instance;
  bool hasFocus = false;
  @override
  Widget build(BuildContext context) {
    int index;

    final docRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth.currentUser!.email);

    Query qmaterials = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth.currentUser!.email)
        .collection("Ürün")
        .where("durum", isEqualTo: 1);

    docRef.snapshots().listen(
          (event) =>
              print('''profil data: ${k_adi.text = event["Kullanıcı Adı"]}
              ${eposta.text = event["Eposta"]}'''),
          onError: (error) => print("Listen failed: $error"),
        );

    var genel0;
    var genel1;
    var malzemeAdi0;
    var malzemeAlmaTarihi0;
    var emanetAlmaSebebi0;
    var malzemeAlan0;
    var malzemeTeslimTarihi0;
    var eksik0;
    var durum0;
    var malzemeAdi1;
    var malzemeAlmaTarihi1;
    var emanetAlmaSebebi1;
    var malzemeAlan1;
    var malzemeTeslimTarihi1;
    var eksik1;
    var durum1;

    final depRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth.currentUser!.email)
        .collection("Ürün");

    yaziGetir() async {
      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(Auth.currentUser!.email)
            .collection("Ürün")
            .where("durum", isEqualTo: 0)
            .get()
            .then((value) {
          List mgenel0 = [];
          List madi0 = [];
          List mAlmaTarihi0 = [];
          List mTeslimTarihi0 = [];
          List mEksik0 = [];
          for (var element in value.docs) {
            madi0.add(element
                .data()["Emanet"]
                .toString()
                .replaceAll('{', '')
                .replaceAll('}', ''));
            malzemeAdi0 = madi0.toList();
            malzemeAlan0 = value.docs[0]["Emanet Alan"];
            emanetAlmaSebebi0 = value.docs[0]["Emanet Alma Sebebi"];
            mAlmaTarihi0.add(element.data()["Emanet Alma Tarihi"]);
            malzemeAlmaTarihi0 = mAlmaTarihi0.toList();
            mTeslimTarihi0.add(element.data()["Teslim Tarihi"]);
            malzemeTeslimTarihi0 = mTeslimTarihi0.toList();
            mEksik0.add(element.data()["Eksik"].toString());
            eksik0 = mEksik0.toList();
            durum0 = value.docs[0]["durum"];
            mgenel0.add('''

${'''Emanet Alınan Ürün: ${element.data()["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet'''}
${'''Emanet Alan Kişi: ${value.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element.data()["Emanet Alma Tarihi"]}'''}
${'''Emanet Teslim Tarihi: ${element.data()["Teslim Tarihi"]}'''}
${'''Eksik Teslim: ${element.data()["Eksik"]}'''}
-----------------------------------------------------------------------------------
''');
            genel0 = mgenel0.toList();
          }
        });
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(Auth.currentUser!.email)
            .collection("Ürün")
            .where("durum", isEqualTo: 1)
            .get()
            .then((value1) {
          List mgenel1 = [];
          List madi1 = [];
          List mAlmaTarihi1 = [];
          List mTeslimTarihi1 = [];
          for (var element in value1.docs) {
            madi1.add(element
                .data()["Emanet"]
                .toString()
                .replaceAll('{', '')
                .replaceAll('}', ''));
            malzemeAdi1 = madi1.toList();
            malzemeAlan1 = value1.docs[0]["Emanet Alan"];
            emanetAlmaSebebi1 = value1.docs[0]["Emanet Alma Sebebi"];
            mAlmaTarihi1.add(element.data()["Emanet Alma Tarihi"]);
            malzemeAlmaTarihi1 = mAlmaTarihi1.toList();
            mTeslimTarihi1.add(element.data()["Teslim Tarihi"]);
            malzemeTeslimTarihi1 = mTeslimTarihi1.toList();
            eksik1 = value1.docs[0]["Eksik"];
            durum1 = value1.docs[0]["durum"];
            mgenel1.add('''

${'''Emanet Alınan Ürün: ${element.data()["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet'''}
${'''Emanet Alan Kişi: ${value1.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value1.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element.data()["Emanet Alma Tarihi"]}'''}
-----------------------------------------------------------------------------------
''');
            genel1 = mgenel1.toList();
          }
        });
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names, empty_catches
      } catch (Error) {}
    }

    Future<void> createExcel() async {
      await yaziGetir();
      final xls.Workbook workbook = xls.Workbook();
      final xls.Worksheet rapor = workbook.worksheets[0];

      /*------------------------------------------------*/
      final xls.Range rangebaslik0 = rapor.getRangeByName('A1');
      rangebaslik0.setText("TESLİM EDİLEN MAZLEMELER");

      final xls.Range range = rapor.getRangeByName('A2');
      range.setText('$genel0'
          .toString()
          .replaceAll(',', '')
          .replaceAll('[', '')
          .replaceAll(']', ''));

      /*-------------------------*/

      final xls.Range rangebaslik1 = rapor.getRangeByName('B1');
      rangebaslik1.setText("TESLİM EDİLMEYEN MAZLEMELER");

      final xls.Range range11 = rapor.getRangeByName('B2');
      range11.setText('$genel1'
          .toString()
          .replaceAll(',', '')
          .replaceAll('[', '')
          .replaceAll(']', ''));

      rangebaslik0.cellStyle.fontColor = "#eb3434";
      rangebaslik0.cellStyle.fontSize = 17;
      rangebaslik0.cellStyle.bold = true;
      range.cellStyle.fontSize = 13;
      range.cellStyle.wrapText = true;
      range.columnWidth = 60;

      rangebaslik1.cellStyle.fontColor = "#eb3434";
      rangebaslik1.cellStyle.fontSize = 17;
      rangebaslik1.cellStyle.bold = true;
      range11.cellStyle.fontSize = 13;
      range11.cellStyle.wrapText = true;
      range11.columnWidth = 60;
      /*------------------------------------------------*/

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(now);
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          '$path/IHH Depo Raporu_${k_adi.text}_$formattedDate.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }

    FocusNode nodeFirst = FocusNode();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFFEBC1),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  key: enabl,
                  focusNode: nodeFirst,
                  enabled: hasFocus,
                  controller: k_adi,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Kullanıcı Adı",
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2)),
                  ),
                ),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                    child: TextField(
                  enabled: hasFocus,
                  controller: eposta,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Eposta",
                    border: InputBorder.none,
                  ),
                )),
              ),
            ),*/
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: qmaterials.snapshots(),
                    builder: (context, snp) {
                      if (snp.hasError) {
                        return const Center(
                          child: Text("Bir Hata Oluştu Tekrar Deneyiniz"),
                        );
                      } else {
                        if (snp.hasData) {
                          List<DocumentSnapshot> malzemeler = snp.data!.docs;
                          return Flexible(
                            child: ListView.builder(
                              itemCount: malzemeler.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: const BorderSide(
                                              color: Colors.black, width: 2)),
                                      color: Colors.white,
                                      child: ListTile(
                                        title: Text(
                                          '${malzemeler[index]["Emanet"]}'
                                              .replaceAll('[', '')
                                              .replaceAll(']', '')
                                              .replaceAll("{", "")
                                              .replaceAll("}", ""),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
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
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: FloatingActionButton(
                    child: const Icon(Icons.print, size: 35),
                    backgroundColor: const Color(0xffd41217),
                    onPressed: () {
                      createExcel();
                    }),
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
