import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add_materials_page.dart';

class MaterialsPage extends StatefulWidget {
  MaterialsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  final _firestore = FirebaseFirestore.instance;
  String name = "";
  var delegate;

  @override
  Widget build(BuildContext context) {
    var malzemeAdi;
    var malzemeQr;
    var malzemeSinifi;
    var malzemeRafi;
    var malzemeKonum;
    var malzemeStok;
    var malzemeImage;

    String filterWord = "";
    CollectionReference materialsRef = _firestore.collection('Materials');
    return Scaffold(
      backgroundColor: Color(0xffFFEBC1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffFFEBC1),
        title: Text(
          "Malzemeler",
          style: TextStyle(fontSize: 26, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMaterialsPage(
                              Qr: '',
                              malzemeAdi: '',
                              malzemeRafi: '',
                              malzemeSinifi: '',
                              malzemeEkleGuncelleButtonText: 'Ekle',
                              malzemeKonum: '',
                              malzemeStok: 0,
                              malzemeImage: '',
                            )));
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.black,
                size: 29,
              )),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Card(
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Arama yapınız..."),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: (name != "")
                    ? materialsRef
                        .where("keyword", arrayContains: name)
                        .snapshots()
                    : materialsRef.orderBy("Malzeme Adı").snapshots(),
                builder: (context, snp) {
                  return (snp.connectionState == ConnectionState.waiting)
                      ? Center(child: CircularProgressIndicator())
                      : Flexible(
                          child: ListView.builder(
                            itemCount: snp.data!.docs.length,
                            itemBuilder: (context, index) {
                              var malzemeler = snp.data!.docs;
                              yaziGetir() async {
                                await malzemeler[index]
                                    .reference
                                    .get()
                                    .then((gelenVeri) {
                                  setState(() {
                                    malzemeAdi = gelenVeri["Malzeme Adı"];
                                    malzemeRafi = gelenVeri["Malzeme Rafı"];
                                    malzemeSinifi = gelenVeri["Malzeme Sınıfı"];
                                    malzemeQr = gelenVeri["Qr Kod"];
                                    malzemeKonum = gelenVeri["Konum"];
                                    malzemeStok = gelenVeri["Stok"];
                                    malzemeImage = gelenVeri["Resim"];
                                  });
                                });
                              }

                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                        color: Colors.black, width: 2)),
                                child: Slidable(
                                  key: ValueKey(index),
                                  endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                            label: "Düzenle",
                                            backgroundColor: Colors.green,
                                            icon: Icons.edit,
                                            onPressed: (contextx) async {
                                              await yaziGetir();
                                              Navigator.push(
                                                  contextx,
                                                  MaterialPageRoute(
                                                      builder: (contextx) =>
                                                          AddMaterialsPage(
                                                            Qr: malzemeQr,
                                                            malzemeAdi:
                                                                malzemeAdi,
                                                            malzemeRafi:
                                                                malzemeRafi,
                                                            malzemeSinifi:
                                                                malzemeSinifi,
                                                            malzemeEkleGuncelleButtonText:
                                                                'Güncelle',
                                                            malzemeKonum:
                                                                malzemeKonum,
                                                            malzemeStok:
                                                                malzemeStok,
                                                            malzemeImage:
                                                                malzemeImage,
                                                          )));
                                            }),
                                        SlidableAction(
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    right: Radius.circular(20)),
                                            label: "Sil",
                                            backgroundColor: Colors.red,
                                            icon: Icons.delete,
                                            onPressed: (dialogcontext) async {
                                              {
                                                await showDialog(
                                                  context: context,
                                                  builder: (builder) =>
                                                      AlertDialog(
                                                    title: Text("Sil"),
                                                    content: Text(
                                                        "Silmek İstediğinize Emin Misiniz?"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("İptal"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await malzemeler[
                                                                  index]
                                                              .reference
                                                              .delete();
                                                          Navigator.pop(
                                                              context);
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Malzeme Silindi");
                                                        },
                                                        child: Text("Tamam"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            })
                                      ]),
                                  child: ListTile(
                                    leading: ClipOval(
                                      child: Image.network(
                                        "${malzemeler[index]['Resim']}",
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    title: Text(
                                      '${malzemeler[index]['Malzeme Adı']}',
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    subtitle: Text(
                                      '''
Malzeme Sınıfı:${malzemeler[index]["${"Malzeme Sınıfı"}"]}
Malzeme Rafı:${malzemeler[index]["${"Malzeme Rafı"}"]}
Malzeme Konumu:${malzemeler[index]["${"Konum"}"]},''',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
