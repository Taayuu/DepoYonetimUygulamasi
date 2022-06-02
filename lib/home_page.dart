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
    List<Widget> pages = [
      FirstPage(),
      GetMaterials(
        Qr: widget.Qr,
        teslimet: false,
        gerigel: false,
        teslimal: false,
      ),
      MaterialsPage(),
      ProfilePage(
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
    final _authService = Provider.of<IAuthService>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Color(0xffFFEBC1),
        height: 65,
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _currentIndexs,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Ana Menü"),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: "Emanet"),
          NavigationDestination(icon: Icon(Icons.list), label: "Malzemeler"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
      backgroundColor: Color(0xffFFEBC1),
      appBar: AppBar(
        title: TextField(
          enabled: false,
          controller: k_adi,
          style: TextStyle(color: Colors.white, fontSize: 20),
          decoration: InputDecoration(border: InputBorder.none),
        ),
        backgroundColor: Color(0xffd41217),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (builder) => AlertDialog(
                    title: Text("Güvenli Çıkış"),
                    content: Text("Çıkmak İstediğinize Emin misiniz?"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Hayır"),
                      ),
                      FlatButton(
                        onPressed: () async {
                          await _authService.signOut();
                          Navigator.pop(context);
                        },
                        child: Text("Evet"),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: pages[_currentIndexs],
      ),
    );
  }
}
