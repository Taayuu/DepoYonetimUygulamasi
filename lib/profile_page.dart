// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, unused_local_variable, non_constant_identifier_names, duplicate_ignore
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ihhdepom/core/service/firebaseKisayol.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'core/service/renk.dart';

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
  bool hasFocus = false;
  @override
  Widget build(BuildContext context) {
    int index;
    userRef.snapshots().listen(
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
    List mgenel0 = [];
    List mgenel1 = [];
    var tarihAlma;
    var zaman = "Günlük";

    yaziGetir() async {
      try {
        if (zaman == "Günlük") {
          await urunCol
              .where("durum", isEqualTo: 0)
              .where("Emanet Alma Tarihi Saatsiz", isEqualTo: tarihAlma)
              .get()
              .then((value) {
            List madi0 = [];
            List mAlmaTarihi0 = [];
            List mTeslimTarihi0 = [];
            List mEksik0 = [];
            mgenel0.clear();
            for (var element in value.docs) {
              mgenel0.add('''

${'''Emanet Alınan Ürün: ${element.data()["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet'''}
${'''Emanet Alan Kişi: ${value.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element.data()["Emanet Alma Tarihi"]}'''}
${'''Emanet Teslim Tarihi: ${element.data()["Teslim Tarihi"]}'''}
${'''Eksik Teslim: ${element.data()["Eksik"]}'''}
''');
              genel0 = mgenel0.toList();
            }
          });
          await urunColDurum1
              .where("Emanet Alma Tarihi Saatsiz", isEqualTo: tarihAlma)
              .get()
              .then((value1) {
            List madi1 = [];
            List mAlmaTarihi1 = [];
            List mTeslimTarihi1 = [];
            mgenel1.clear();
            for (var element in value1.docs) {
              mgenel1.add('''

${'''Emanet Alınan Ürün: ${element["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet mevcut ${element["İlk Alınan"]} adet alındı'''}
${'''Emanet Alan Kişi: ${value1.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value1.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element["Emanet Alma Tarihi"]}'''}
''');
              genel1 = mgenel1.toList();
            }
          });
        } else if (zaman == "Haftalık") {
          await urunCol
              .where("durum", isEqualTo: 0)
              .where("Emanet Alma Tarihi Saatsiz",
                  isGreaterThanOrEqualTo: tarihAlma)
              .get()
              .then((value) {
            List madi0 = [];
            List mAlmaTarihi0 = [];
            List mTeslimTarihi0 = [];
            List mEksik0 = [];
            mgenel0.clear();
            for (var element in value.docs) {
              mgenel0.add('''

${'''Emanet Alınan Ürün: ${element.data()["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet'''}
${'''Emanet Alan Kişi: ${value.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element.data()["Emanet Alma Tarihi"]}'''}
${'''Emanet Teslim Tarihi: ${element.data()["Teslim Tarihi"]}'''}
${'''Eksik Teslim: ${element.data()["Eksik"]}'''}
''');
              genel0 = mgenel0.toList();
            }
          });
          await urunColDurum1
              .where("Emanet Alma Tarihi Saatsiz",
                  isLessThanOrEqualTo: tarihAlma)
              .get()
              .then((value1) {
            List madi1 = [];
            List mAlmaTarihi1 = [];
            List mTeslimTarihi1 = [];
            mgenel1.clear();
            for (var element in value1.docs) {
              mgenel1.add('''

${'''Emanet Alınan Ürün: ${element["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet mevcut ${element["İlk Alınan"]} adet alındı'''}
${'''Emanet Alan Kişi: ${value1.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value1.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element["Emanet Alma Tarihi"]}'''}
''');
              genel1 = mgenel1.toList();
            }
          });
        } else if (zaman == "Aylık") {
          await urunCol
              .where("durum", isEqualTo: 0)
              .where("Emanet Alma Tarihi Saatsiz", isEqualTo: tarihAlma)
              .get()
              .then((value) {
            List madi0 = [];
            List mAlmaTarihi0 = [];
            List mTeslimTarihi0 = [];
            List mEksik0 = [];
            mgenel0.clear();
            for (var element in value.docs) {
              mgenel0.add('''

${'''Emanet Alınan Ürün: ${element.data()["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet'''}
${'''Emanet Alan Kişi: ${value.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element.data()["Emanet Alma Tarihi"]}'''}
${'''Emanet Teslim Tarihi: ${element.data()["Teslim Tarihi"]}'''}
${'''Eksik Teslim: ${element.data()["Eksik"]}'''}
''');
              genel0 = mgenel0.toList();
            }
          });
          await urunColDurum1
              .where("Emanet Alma Tarihi Saatsiz", isEqualTo: tarihAlma)
              .get()
              .then((value1) {
            List madi1 = [];
            List mAlmaTarihi1 = [];
            List mTeslimTarihi1 = [];
            mgenel1.clear();
            for (var element in value1.docs) {
              mgenel1.add('''

${'''Emanet Alınan Ürün: ${element["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet mevcut ${element["İlk Alınan"]} adet alındı'''}
${'''Emanet Alan Kişi: ${value1.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value1.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element["Emanet Alma Tarihi"]}'''}
''');
              genel1 = mgenel1.toList();
            }
          });
        } else if (zaman == "Genel") {
          await urunCol.where("durum", isEqualTo: 0).get().then((value) {
            List madi0 = [];
            List mAlmaTarihi0 = [];
            List mTeslimTarihi0 = [];
            List mEksik0 = [];
            mgenel0.clear();
            for (var element in value.docs) {
              mgenel0.add('''

${'''Emanet Alınan Ürün: ${element.data()["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet'''}
${'''Emanet Alan Kişi: ${value.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element.data()["Emanet Alma Tarihi"]}'''}
${'''Emanet Teslim Tarihi: ${element.data()["Teslim Tarihi"]}'''}
${'''Eksik Teslim: ${element.data()["Eksik"]}'''}
''');
              genel0 = mgenel0.toList();
            }
          });
          await urunColDurum1.get().then((value1) {
            List madi1 = [];
            List mAlmaTarihi1 = [];
            List mTeslimTarihi1 = [];
            mgenel1.clear();
            for (var element in value1.docs) {
              mgenel1.add('''

${'''Emanet Alınan Ürün: ${element["Emanet"].toString().replaceAll('{', '').replaceAll('}', '')} adet mevcut ${element["İlk Alınan"]} adet alındı'''}
${'''Emanet Alan Kişi: ${value1.docs[0]["Emanet Alan"]}'''}
${'''Emanet Alma Sebebi: ${value1.docs[0]["Emanet Alma Sebebi"]}'''}
${'''Emanet Alma Tarihi: ${element["Emanet Alma Tarihi"]}'''}
''');
              genel1 = mgenel1.toList();
            }
          });
        }
        // ignore: non_constant_identifier_names, avoid_types_as_parameter_names, empty_catches
      } catch (Error) {}
    }

    Future<void> createExcel() async {
      await yaziGetir();
      final xls.Workbook workbook = xls.Workbook();
      final xls.Worksheet rapor = workbook.worksheets[0];
      rapor.name = "Emanet Raporu";

      /*------------------------------------------------*/
      final xls.Range rangebaslikBuyuk = rapor.getRangeByName('A1');
      rangebaslikBuyuk.setText("$zaman Emanet Raporu");

      rangebaslikBuyuk.cellStyle.fontColor = "#eb3434";
      rangebaslikBuyuk.cellStyle.fontSize = 18;
      rangebaslikBuyuk.cellStyle.bold = true;

      final xls.Range rangebaslik0 = rapor.getRangeByName('A2');
      rangebaslik0.setText("TESLİM EDİLEN MAZLEMELER");

      rangebaslik0.cellStyle.fontColor = "#eb3434";
      rangebaslik0.cellStyle.fontSize = 13;
      rangebaslik0.cellStyle.bold = true;

      try {
        if (mgenel0.length == 1) {
          final xls.Range list =
              rapor.getRangeByName('A3:A${mgenel0.length + 3}');
          rapor.importList(mgenel0, 3, 1, true);
          list.columnWidth = 60;
          list.cellStyle.wrapText = true;
        } else {
          final xls.Range list =
              rapor.getRangeByName('A3:A${mgenel0.length + 2}');
          rapor.importList(mgenel0, 3, 1, true);
          list.columnWidth = 60;
          list.cellStyle.wrapText = true;
        }
      } catch (e) {
        print(e);
      }

      /*-------------------------*/

      final xls.Range rangebaslik1 = rapor.getRangeByName('B2');
      rangebaslik1.setText("TESLİM EDİLMEYEN MAZLEMELER");

      rangebaslik1.cellStyle.fontColor = "#eb3434";
      rangebaslik1.cellStyle.fontSize = 13;
      rangebaslik1.cellStyle.bold = true;

      try {
        if (mgenel1.length == 1) {
          final xls.Range list1 =
              rapor.getRangeByName('B3:B${mgenel1.length + 3}');
          rapor.importList(mgenel1, 3, 2, true);
          list1.columnWidth = 60;
          list1.cellStyle.wrapText = true;
        } else {
          final xls.Range list1 =
              rapor.getRangeByName('B3:B${mgenel1.length + 2}');
          rapor.importList(mgenel1, 3, 2, true);
          list1.columnWidth = 60;
          list1.cellStyle.wrapText = true;
        }
      } catch (e) {
        print(e);
      }

      /*------------------------------------------------*/

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(now);
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          '$path/IHH $zaman Depo Raporu_${k_adi.text}_$formattedDate.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }

    FocusNode nodeFirst = FocusNode();

    return SafeArea(
      child: Scaffold(
        backgroundColor: anaRenk,
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
                    fillColor: white,
                    filled: true,
                    hintText: "Kullanıcı Adı",
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: black, width: 2)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: urunColDurum1.snapshots(),
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
                                      color: white,
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
                  child: SpeedDial(
                    overlayColor: Colors.red,
                    overlayOpacity: 0,
                    curve: Curves.easeInQuart,
                    child: const Icon(Icons.print, size: 35),
                    backgroundColor: const Color(0xffd41217),
                    childMargin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 17),
                    buttonSize: const Size(65.0, 60.0),
                    children: [
                      SpeedDialChild(
                          child: const Icon(Icons.today,
                              size: 35, color: Colors.white),
                          label: "Günlük Rapor",
                          backgroundColor:
                              const Color.fromARGB(255, 255, 208, 0),
                          onTap: () {
                            setState(() {
                              zaman = "Günlük";
                              tarihAlma = DateFormat("dd-MM-yyyy")
                                  .format(DateTime.now());
                            });
                            createExcel();
                          }),
                      SpeedDialChild(
                          child: const Icon(Icons.view_day,
                              size: 35, color: Colors.white),
                          label: "Tüm Raporlar",
                          backgroundColor:
                              const Color.fromARGB(255, 18, 37, 212),
                          onTap: () {
                            setState(() {
                              zaman = "Genel";
                            });
                            createExcel();
                          }),
                    ],
                  )),
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
