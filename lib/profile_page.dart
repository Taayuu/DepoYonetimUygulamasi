// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, non_constant_identifier_names

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
          List madi0 = [];
          List mAlmaTarihi0 = [];
          List mTeslimTarihi0 = [];
          value.docs.forEach((element) {
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
            eksik0 = value.docs[0]["Eksik"];
            durum0 = value.docs[0]["durum"];
          });
        });
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(Auth.currentUser!.email)
            .collection("Ürün")
            .where("durum", isEqualTo: 1)
            .get()
            .then((value1) {
          List madi1 = [];
          List mAlmaTarihi1 = [];
          List mTeslimTarihi1 = [];
          value1.docs.forEach((element) {
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
          });
        });
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names, empty_catches
      } catch (Error) {}
    }

    Future<void> createExcel() async {
      await yaziGetir();
      final xls.Workbook workbook = xls.Workbook();
      final xls.Worksheet rapor = workbook.worksheets[0];

      /*------------------------------------------------*/
      final xls.Range rangebaslik = rapor.getRangeByName('A1');
      rangebaslik.setText("TESLİM EDİLEN MAZLEMELER");

      final xls.Range range = rapor.getRangeByName('A2');
      range.setText("Emanet Adı: $malzemeAdi0");

      final xls.Range range1 = rapor.getRangeByName('A3');
      range1.setText("Emanet Alma Sebebi: $emanetAlmaSebebi0");

      final xls.Range range2 = rapor.getRangeByName('A4');
      range2.setText("Teslim Alan: $malzemeAlan0");

      final xls.Range range3 = rapor.getRangeByName('A5');
      range3.setText("Emanet Alma Tarihi: $malzemeAlmaTarihi0");

      final xls.Range range4 = rapor.getRangeByName('A6');
      range4.setText("Teslim Tarihi: $malzemeTeslimTarihi0");

      final xls.Range range5 = rapor.getRangeByName('A7');
      range5.setText("Eksik Sayısı: $eksik0");
      /*-------------------------*/

      final xls.Range rangebaslik1 = rapor.getRangeByName('A10');
      rangebaslik1.setText("TESLİM EDİLMEYEN MAZLEMELER");

      final xls.Range range11 = rapor.getRangeByName('A11');
      range11.setText("Emanet Adı: $malzemeAdi1");

      final xls.Range range12 = rapor.getRangeByName('A12');
      range12.setText("Emanet Alma Sebebi: $emanetAlmaSebebi1");

      final xls.Range range23 = rapor.getRangeByName('A13');
      range23.setText("Teslim Alan: $malzemeAlan1");

      final xls.Range range34 = rapor.getRangeByName('A14');
      range34.setText("Emanet Alma Tarihi: $malzemeAlmaTarihi1");

      final xls.Range range45 = rapor.getRangeByName('A15');
      range45.setText("Teslim Tarihi: Teslim Eilmedi");

      final xls.Range range56 = rapor.getRangeByName('A16');
      range56.setText("Eksik Sayısı: $eksik1");

      range.autoFit();
      range1.autoFit();
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
                    backgroundColor: Color(0xffd41217),
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
