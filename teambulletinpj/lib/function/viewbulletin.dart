import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html/flutter_html.dart';

class viewBulletinPDF extends StatefulWidget {
  viewBulletinPDF({Key? key, this.pdfURL}) : super(key: key);

  final String? pdfURL;

  @override
  _ViewBulletinPDFState createState() => _ViewBulletinPDFState();
}

class _ViewBulletinPDFState extends State<viewBulletinPDF> {
  String remotePDF = "";
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      print(f.path);
      setState(() {
        print("setState!!!!");
        remotePDF = f.path;
      });
    });
  }
  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      final url = '${widget.pdfURL}';
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      print("------------> test");
      //completer.complete(file);
      return file;
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
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
        title: Text('주보',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Text(remotePDF),
          if(remotePDF == "") ... [
            Center(
              child: Text("Loading..."),
            )
          ] else ... [
            PDFView(
              filePath: remotePDF,
              //   enableSwipe: true,
              //   swipeHorizontal: true,
              //   autoSpacing: false,
              //   pageFling: true,
              //   pageSnap: true,
              //   defaultPage: currentPage!,
              //   fitPolicy: FitPolicy.BOTH,
              //   preventLinkNavigation: false,
              //   onRender: (_pages) {
              //     setState(() {
              //       pages = _pages;
              //       isReady = true;
              //     });
              //   },
              //   onError: (error) {
              //     setState(() {
              //       errorMessage = error.toString();
              //     });
              //     print(error.toString());
              //   },
              //   onPageError: (page, error) {
              //     setState(() {
              //       errorMessage = '$page: ${error.toString()}';
              //     });
              //     print('$page: ${error.toString()}');
              //   },
              //   onViewCreated: (PDFViewController pdfViewController) {
              //     _controller.complete(pdfViewController);
              //   },
              //   onLinkHandler: (String? uri) {
              //     print('goto uri: $uri');
              //   },
              //   onPageChanged: (int? page, int? total) {
              //     print('page change: $page/$total');
              //     setState(() {
              //       currentPage = page;
              //     });
              //   },
              // ),
              // errorMessage.isEmpty
              //     ? !isReady
              //         ? Center(
              //             child: CircularProgressIndicator(),
              //           )
              //         : Container()
              //     : Center(
              //       child: Text(errorMessage),
            )
          ]
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}

class viewBulletinHTML extends StatefulWidget {
  viewBulletinHTML({Key? key, this.html}) : super(key: key);

  final String? html;

  @override
  _ViewBulletinHTMLState createState() => _ViewBulletinHTMLState();
}

class _ViewBulletinHTMLState extends State<viewBulletinHTML> {
  HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('주보',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
      ),
      body: ListView(
        children: [
          Html(
            data: widget.html,
          ),
        ],
      ),
    );
  }
}
