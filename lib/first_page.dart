// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  FirebaseAuth Auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFFEBC1),
        body: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: usersRef.where("Emanetler", isNotEqualTo: []).snapshots(),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Colors.black, width: 2)),
                                    color: Colors.white,
                                    child: ListTile(
                                      title: Text(
                                        '${malzemeler[index]['Kullanıcı Adı']}',
                                        style: const TextStyle(fontSize: 19),
                                      ),
                                      subtitle: Text(
                                        '${malzemeler[index]["Emanetler"]}'
                                            .replaceAll('[', '')
                                            .replaceAll(']', ''),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ));
                          }),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
