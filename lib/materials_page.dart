// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable

import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'add_materials_page.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  final _firestore = FirebaseFirestore.instance;
  String name = "";
  var delegate;

  FirebaseAuth Auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var malzemeAdi;
    var malzemeQr;
    var malzemeSinifi;
    var malzemeRafi;
    var malzemeStok;
    var malzemeImage;
    var ID;

    CollectionReference materialsRef = _firestore.collection('Materials');
    return Scaffold(
      backgroundColor: const Color(0xffFFEBC1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffFFEBC1),
        title: const Text(
          "Malzemeler",
          style: TextStyle(fontSize: 26, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Card(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 3)),
                      prefixIcon: const Icon(Icons.search),
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
                      ? const Center(child: CircularProgressIndicator())
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
                                    malzemeStok = gelenVeri["Stok"];
                                    malzemeImage = gelenVeri["Resim"];
                                    ID = gelenVeri["ID"];
                                  });
                                });
                              }

                              return Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Colors.black, width: 2)),
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
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  subtitle: Text(
                                    '''
Qr Kod: ${malzemeler[index]["Qr Kod"]}
Malzeme Rafı: ${malzemeler[index]["Malzeme Rafı"]}
Malzeme Konumu: ${malzemeler[index]["Konum"].toString().replaceAll(']', '').replaceAll('[', '')}
Stok: ${malzemeler[index]["Stok"]}''',
                                    style: const TextStyle(fontSize: 13),
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
