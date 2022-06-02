import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'home_page.dart';

class CreateQr extends StatefulWidget {
  @override
  State<CreateQr> createState() => _CreateQrState();
}

class _CreateQrState extends State<CreateQr> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              QrImage(
                data: controller.text,
                size: 200,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 40),
              buildTextField(context),
              SizedBox(height: 40),
              RaisedButton(
                  child: Text("Geri"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  Qr: '',
                                )));
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context) => TextField(
        controller: controller,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        decoration: InputDecoration(
          hintText: 'Veri Giriniz',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
          ),
          suffixIcon: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: Icon(
              Icons.done,
              size: 30,
            ),
            onPressed: () => setState(() {}),
          ),
        ),
      );
}
