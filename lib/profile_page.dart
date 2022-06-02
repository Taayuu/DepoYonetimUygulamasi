import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  @override
  Widget build(BuildContext context) {
    int index;
    bool hasFocus = false;
    final docRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth.currentUser!.email);

    Query qmaterials = FirebaseFirestore.instance
        .collection("Users")
        .where("Id", isEqualTo: Auth.currentUser!.uid);

    docRef.snapshots().listen(
          (event) => print(
              '''profil data: ${k_adi.text = event.data()!["Kullanıcı Adı"]}
              ${eposta.text = event.data()!["Eposta"]}'''),
          onError: (error) => print("Listen failed: $error"),
        );
    var malzemeAdi;
    var malzemeAlmaTarihi;
    var malzemeAlan;
    var malzemeTeslimTarihi;

    final depRef = FirebaseFirestore.instance
        .collection("Deposit")
        .doc(Auth.currentUser!.email)
        .collection("Emanetlerim")
        .doc(Auth.currentUser!.email);

    yaziGetir() async {
      await depRef.get().then((gelenVeri) {
        setState(() {
          malzemeAdi = gelenVeri["Emanet Adı"];
          malzemeAlan = gelenVeri.data()!["Emanet Alan"];
          malzemeAlmaTarihi = gelenVeri.data()!["Emanet Alma Tarihi"];
          malzemeTeslimTarihi = gelenVeri.data()!["Teslim Tarihi"];
        });
      });
    }

    Future<void> createExcel() async {
      await yaziGetir();
      final xls.Workbook workbook = xls.Workbook();
      final xls.Worksheet rapor = workbook.worksheets[0];
      /*------------------------------------------------*/
      final xls.Range range = rapor.getRangeByName('A1');
      range.setText("Emanet Adı: ${malzemeAdi}");

      final xls.Range range1 = rapor.getRangeByName('A2');
      range1.setText("Teslim Alan: ${malzemeAlan}");

      final xls.Range range2 = rapor.getRangeByName('A3');
      range2.setText("Emanet Alma Tarihi: ${malzemeAlmaTarihi}");

      final xls.Range range3 = rapor.getRangeByName('A4');
      range3.setText("Teslim Tarihi: ${malzemeTeslimTarihi}");

      range.autoFit();
      range1.autoFit();
      /*------------------------------------------------*/
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          '$path/IHH Depo Raporu_${k_adi.text}_${formattedDate}.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFEBC1),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                    child: TextField(
                  key: enabl,
                  enabled: hasFocus,
                  controller: k_adi,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Kullanıcı Adı",
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                  ),
                )),
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
                  child: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: qmaterials.snapshots(),
                      builder: (context, snp) {
                        if (snp.hasError) {
                          return Center(
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
                                            side: BorderSide(
                                                color: Colors.black, width: 2)),
                                        color: Colors.white,
                                        child: ListTile(
                                          title: Text(
                                            '${malzemeler[index]["Emanetler"]}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                      },
                    ),
/*TextField(
                      controller: emanetler,
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),*/
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FloatingActionButton(
                    child: Icon(Icons.print, size: 35),
                    backgroundColor: Color(0xffd41217),
                    onPressed: () {
                      createExcel();
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FloatingActionButton(
                    child: Icon(Icons.edit, size: 35),
                    backgroundColor: Color(0xffd41217),
                    onPressed: () {
                      hasFocus = true;
                      Fluttertoast.showToast(msg: "Kaleme Basıldı");
                      setState(() {
                        hasFocus = true;
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
