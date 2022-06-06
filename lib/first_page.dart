import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference materialsRef =
        FirebaseFirestore.instance.collection('Users');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFFEBC1),
        body: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: materialsRef
                    .where("Emanetler", isNotEqualTo: []).snapshots(),
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                              color: Colors.black, width: 2)),
                                      color: Colors.white,
                                      child: ListTile(
                                        title: Text(
                                          '${malzemeler[index]['Kullanıcı Adı']}',
                                          style: TextStyle(fontSize: 19),
                                        ),
                                        subtitle: Text(
                                          '${malzemeler[index]["Emanetler"]}'
                                              .replaceAll('[', '')
                                              .replaceAll(']', ''),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ));
                            }),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
