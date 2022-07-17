// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth Auth = FirebaseAuth.instance;

final DocumentReference<Map<String, dynamic>> userRef =
    FirebaseFirestore.instance.collection("Users").doc(Auth.currentUser!.email);

final CollectionReference<Map<String, dynamic>> urunCol =
    userRef.collection("Ürün");

final CollectionReference materialsRef =
    FirebaseFirestore.instance.collection("Materials");

final Future<DocumentSnapshot<Map<String, dynamic>>> userGet =
    FirebaseFirestore.instance.collection("AppControl").doc("AdminMail").get();

final Query urunColDurum1 = FirebaseFirestore.instance
    .collection("Users")
    .doc(Auth.currentUser!.email)
    .collection("Ürün")
    .where("durum", isEqualTo: 1);
