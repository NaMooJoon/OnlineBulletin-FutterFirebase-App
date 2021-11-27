import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WriteBulletin extends StatefulWidget {
  WriteBulletin({Key? key}) : super(key: key);

  @override
  _WriteBulletinPage createState() => _WriteBulletinPage();
}

class _WriteBulletinPage extends State<WriteBulletin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('주보 작성',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
      ),
    );
  }
}

class CapturedBulletin extends StatefulWidget {
  CapturedBulletin({Key? key}) : super(key: key);

  @override
  _CapturedBulletinPage createState() => _CapturedBulletinPage();
}

class _CapturedBulletinPage extends State<CapturedBulletin> {
  PDFDocument? _scannedDocument;
  File? _scannedDocumentFile;

  openPdfScanner(BuildContext context) async {
    var doc = await DocumentScannerFlutter.launchForPdf(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Steps",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: "Only 1 Page",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE:
        "Only {PAGES_COUNT} Page"
      },
      //source: ScannerFileSource.CAMERA
    );
    if (doc != null) {
      _scannedDocument = null;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 100));
      _scannedDocumentFile = doc;
      _scannedDocument = await PDFDocument.fromFile(doc);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('주보 스캐',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_scannedDocument != null) ...[
            Expanded(
              child: PDFViewer(
                document: _scannedDocument!,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${_scannedDocumentFile?.path}"),
            ),
          ],
          Center(
            child: Builder(builder: (context) {
              return ElevatedButton(
                  onPressed: () => openPdfScanner(context),
                  child: Text("PDF Scan"));
            }),
          ),
        ],
      ),
    );
  }
}