import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:phone_login_app/globalvariables.dart';

import 'globalvariablesinpages.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      await storage.ref('sem/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('sem').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found Sem file: $ref');
    });

    return results;
  }

  Future<String> downloadURL(String pdfName) async {
    pname = pdfName;
    print("pname=$pname");
    String downloadURL =
        (await storage.ref('sem/$pdfName').getDownloadURL())!.toString();
    print("Download-URL:$downloadURL");
    requrl = '';
    requrl = downloadURL;
    print("requrl in downloadURL:$requrl");
    return Future.delayed(const Duration(seconds: 1), (() => downloadURL));
  }
}

class StorageView extends StatefulWidget {
  final String urlo;
  const StorageView({Key? key, required this.urlo}) : super(key: key);

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  final Storage storage = Storage();

  late PDFDocument _doc;
  late bool _loading;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  _initPdf() async {
    setState(() {
      _loading = true;
    });
    print("required url in pdf = ${requrl}".toString());

    final doc = await PDFDocument.fromURL(await useurl);

    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Deep-PDF Viewer",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: _loading
          ? Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                      "Fact: It doesn't take much to read a lot of words...",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Open Sans',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 19),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "images/Waitda.jpg",
                )
              ],
            )
          : PDFViewer(
              document: _doc,
              indicatorBackground: Colors.deepOrangeAccent,
              showIndicator: true,
              showPicker: true,
            ),
    );
  }
}
