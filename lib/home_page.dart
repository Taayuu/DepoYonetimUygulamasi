// ignore_for_file: unused_element, must_be_immutable, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/service/i_auth_service.dart';
import 'first_page.dart';
import 'get_materials_page.dart';
import 'materials_page.dart';
import 'profile_page.dart';

//ANASAYFA
const TextStyle _textStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.currentIndexs = 0, required this.Qr})
      : super(key: key);
  int currentIndexs;
  final String Qr;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth Auth = FirebaseAuth.instance;
  TextEditingController k_adi = TextEditingController();
  int _currentIndexs = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndexs = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: true);
    FirebaseFirestore.instance
        .collection("Users")
        .where("Eposta", isEqualTo: Auth.currentUser!.email)
        .snapshots()
        .listen((event) async {
      if (event.docs.isEmpty || event.docs[0]["Eposta"] == null) {
        await _authService.signOut();
      }
    });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth.currentUser!.email)
        .snapshots()
        .listen((event) async {
      if (event.data()!["Eposta"] == "" || event.data()!["Eposta"] == null) {
        await _authService.signOut();
      }
    });

    List<Widget> pages = [
      const FirstPage(),
      GetMaterials(
        Qr: widget.Qr,
        teslimet: false,
        gerigel: false,
        teslimal: false,
      ),
      const MaterialsPage(),
      const ProfilePage(
        malzeme: '',
      ),
    ];
    final docRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(Auth.currentUser!.email);
    docRef.snapshots().listen(
          (event) => print(
              '''home data: ${k_adi.text = '''Hoşgeldiniz: ${event.data()!["Kullanıcı Adı"]}'''}'''),
          onError: (error) => print("Listen failed: $error"),
        );
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xffFFEBC1),
        height: 65,
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _currentIndexs,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Ana Sayfa"),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: "Emanet"),
          NavigationDestination(icon: Icon(Icons.list), label: "Malzemeler"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
      backgroundColor: const Color(0xffFFEBC1),
      appBar: AppBar(
        title: TextField(
          enabled: false,
          controller: k_adi,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
        backgroundColor: const Color(0xffd41217),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (builder) => AlertDialog(
                    title: const Text("Güvenli Çıkış"),
                    content: const Text("Çıkmak İstediğinize Emin Misiniz?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Hayır"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _authService.signOut();
                          Navigator.pop(context);
                        },
                        child: const Text("Evet"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: pages[_currentIndexs],
      ),
    );
  }
}
