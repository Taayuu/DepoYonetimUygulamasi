import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/core/model/my_app_user.dart';
import 'package:login/core/service/firebase_service.dart';
import 'package:login/core/service/i_auth_service.dart';
import 'package:login/core/widgets/auth_widget.dart';
import 'package:login/core/widgets/auth_widget_builder.dart';
import 'package:login/create_qr.dart';
import 'package:login/scan_qr_add.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String version;
  FirebaseFirestore.instance
      .collection("AppControl")
      .doc("İnfo")
      .snapshots()
      .listen((gelenVeri) {
    version = gelenVeri["Version"].toString();
    if (version == "1.0") {
      runApp(const MyApp());
    } else {
      Fluttertoast.showToast(
          msg: "Lütfen uygulamanızı yeni sürüme yükseltiniz",
          gravity: ToastGravity.CENTER,
          fontSize: 20,
          backgroundColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white);
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<IAuthService>(create: (_) => AuthService())],
      child: AuthWidgetBuilder(
        onPageBuilder: (context, AsyncSnapshot<MyAppUser?> snapshot) =>
            MaterialApp(
          theme: ThemeData(fontFamily: "Cabin"),
          debugShowCheckedModeBanner: false,
          home: AuthWidget(snapshot: snapshot),
          routes: <String, WidgetBuilder>{
            '/page1': (BuildContext context) => const CreateQr(),
            '/page2': (BuildContext context) => const ScanQrAdd(),
          },
        ),
      ),
    );
  }
}
