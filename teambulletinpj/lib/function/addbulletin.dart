import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shrine/provider/churchProvider.dart';

class CapturedBulletin extends StatefulWidget {
  CapturedBulletin({Key? key}) : super(key: key);

  @override
  _CapturedBulletinPage createState() => _CapturedBulletinPage();
}

class _CapturedBulletinPage extends State<CapturedBulletin> {
  PDFDocument? _scannedDocument;
  File? _scannedDocumentFile;
  String pdfURL = "";

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

  Future<DocumentReference<Map<String, dynamic>>> uploadPdf(File? pdf) async {
    await _uploadPdf(pdf);
    return FirebaseFirestore.instance.collection('church')
        .doc(Provider.of<ChurchProvider>(context, listen: false).church.id)
        .collection('bulletin')
        .add({
      'pdfURL' : pdfURL,
      'createAt': DateTime.now().millisecondsSinceEpoch,
      'isPDF' : true,
    });
  }


  Future _uploadPdf(File? pdf) async {
    if (pdf == null) return;

    final fileName = pdf.path.split('/').last;
    final destination = 'images/$fileName';

    final ref = FirebaseStorage.instance.ref(destination);

    UploadTask? task = ref.putFile(pdf);

    if (task == null) return ;

    final snapshot = await task.whenComplete(() {});
    pdfURL = await snapshot.ref.getDownloadURL();
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
        title: Text('주보 스캔',
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

            Center(
              child: Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () => uploadPdf(_scannedDocumentFile).then((value) => Navigator.pop(context)),
                    child: Text("Submit"));
              }),
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



class _HtmlEditorExampleState extends State<HtmlEditorExample> {
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();

  Future<void> addBulletin(String bulletinId, var text) {
    return FirebaseFirestore.instance.collection('church')
        .doc(bulletinId)
        .collection('bulletin')
        .add({
      'createAt' : DateTime.now().millisecondsSinceEpoch,
      'html' : text,
      'isPDF' : false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  if (kIsWeb) {
                    controller.reloadWeb();
                  } else {
                    controller.editorController!.reload();
                  }
                })
          ],
        ),
        floatingActionButton: Container(
          height: 50,
          width: 50,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                controller.toggleCodeView();
              },
              child: Text(r'<\>',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              HtmlEditor(
                controller: controller,
                htmlEditorOptions: HtmlEditorOptions(
                  hint: 'Your text here...',
                  shouldEnsureVisible: true,
                  //initialText: "<p>text content initial, if any</p>",
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.aboveEditor, //by default
                  toolbarType: ToolbarType.nativeGrid, //by default
                  onButtonPressed: (ButtonType type, bool? status,
                      Function()? updateStatus) {
                    print(
                        "button '${describeEnum(type)}' pressed, the current selected status is $status");
                    return true;
                  },
                  onDropdownChanged: (DropdownType type, dynamic changed,
                      Function(dynamic)? updateSelectedItem) {
                    print(
                        "dropdown '${describeEnum(type)}' changed to $changed");
                    return true;
                  },
                  mediaLinkInsertInterceptor:
                      (String url, InsertFileType type) {
                    print(url);
                    return true;
                  },
                  mediaUploadInterceptor:
                      (PlatformFile file, InsertFileType type) async {
                    print(file.name); //filename
                    print(file.size); //size in bytes
                    print(file.extension); //file extension (eg jpeg or mp4)
                    return true;
                  },
                ),
                otherOptions: OtherOptions(height: 550),
                callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                  print('html before change is $currentHtml');
                }, onChangeContent: (String? changed) {
                  print('content changed to $changed');
                }, onChangeCodeview: (String? changed) {
                  print('code changed to $changed');
                }, onChangeSelection: (EditorSettings settings) {
                  print('parent element is ${settings.parentElement}');
                  print('font name is ${settings.fontName}');
                }, onDialogShown: () {
                  print('dialog shown');
                }, onEnter: () {
                  print('enter/return pressed');
                }, onFocus: () {
                  print('editor focused');
                }, onBlur: () {
                  print('editor unfocused');
                }, onBlurCodeview: () {
                  print('codeview either focused or unfocused');
                }, onInit: () {
                  print('init');
                },
                    //this is commented because it overrides the default Summernote handlers
                    /*onImageLinkInsert: (String? url) {
                    print(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                    print(file.base64);
                  },*/
                    onImageUploadError: (FileUpload? file, String? base64Str,
                        UploadError error) {
                      print(describeEnum(error));
                      print(base64Str ?? '');
                      if (file != null) {
                        print(file.name);
                        print(file.size);
                        print(file.type);
                      }
                    }, onKeyDown: (int? keyCode) {
                      print('$keyCode key downed');
                      print(
                          'current character count: ${controller.characterCount}');
                    }, onKeyUp: (int? keyCode) {
                      print('$keyCode key released');
                    }, onMouseDown: () {
                      print('mouse downed');
                    }, onMouseUp: () {
                      print('mouse released');
                    }, onNavigationRequestMobile: (String url) {
                      print(url);
                      return NavigationActionPolicy.ALLOW;
                    }, onPaste: () {
                      print('pasted into editor');
                    }, onScroll: () {
                      print('editor scrolled');
                    }),
                plugins: [
                  SummernoteAtMention(
                      getSuggestionsMobile: (String value) {
                        var mentions = <String>['test1', 'test2', 'test3'];
                        return mentions
                            .where((element) => element.contains(value))
                            .toList();
                      },
                      mentionsWeb: ['test1', 'test2', 'test3'],
                      onSelect: (String value) {
                        print(value);
                      }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        controller.undo();
                      },
                      child:
                      Text('Undo', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        controller.clear();
                      },
                      child:
                      Text('Reset', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor),
                      onPressed: () async {
                        var txt = await controller.getText();
                        if (txt.contains('src=\"data:')) {
                          txt =
                          '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                        }
                        addBulletin(Provider.of<ChurchProvider>(context, listen: false).church.id, txt);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor),
                      onPressed: () {
                        controller.redo();
                      },
                      child: Text(
                        'Redo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(result),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor),
                      onPressed: () {
                        controller.insertHtml(
                          '''
                            <h3>주일 오전 예배</h3><br>
                            <h4>1부: 오전 9시</h4><br>
                            <h4>2부: 오전 11시 예배인도/ 1부, 2부 : 홍길동 목사</h4><br>
                            <br>
                            <pre><strong>*표는 일어서서</strong><br></pre>
                            <pre>묵 도    --------주 악--------  다함께묵도<br></pre>
                            <pre>성 시    --------주 악--------  다 함 께<br></pre>
                            <pre>*찬 송   --------주 악--------  다 함 께<br></pre>
                            <pre>*성시교독 --------주 악--------  다 함 께<br></pre>
                            <pre>*신앙고백	--------주 악--------  다 함 께<br></pre>
                            <pre>*찬 송   --------주 악--------  다 함 께<br></pre>
                            <pre>목회기독   --------주 악--------  홍길동목사<br></pre>
                            <pre>성경봉독   --------주 악--------  사 회 자<br></pre>
                            <pre>찬 양    --------주 악--------  성 가 대<br></pre>
                            <pre>설 교    --------주 악--------  홍길동목사<br></pre>
                            <pre>헌금봉헌  --------주 악--------  홍길동집사<br></pre>
                            <pre>광 고    --------주 악--------  사 회 자<br></pre>
                            <pre>*찬 송   --------주 악--------  다 함 께<br></pre>
                            <pre>*축 도   --------주 악--------  홍길동목사<br></pre>
                            <pre>*폐 회   --------주 악--------  성도의교제<br></pre>
                          
                          '''
                        );
                      },
                      child: Text('Insert Icons',
                          style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor),
                      onPressed: () {
                        controller.insertHtml(
                            '''<style>
                                #title {
                                  padding: 7px;
                                  background-color: DodgerBlue;
                                  border-radius: 15px;
                                }
                                #Handong {
                                  color: white;
                                  text-align: center;
                                }
                                #title_text {
                                  font-family: verdana;
                                  font-size: 20px;
                                  color: white;
                                }
                                </style>
                                <div id="title">
                                  <h1 id="Handong">Handong Chapel</h1>
                                  <p id="title_text">Welcome to handong!</p>
                                <div>''');
                      },
                      child: Text('Insert Title',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor),
                      onPressed: () async {
                        controller.insertLink(
                            'Handong linked', 'https://hisnet.handong.edu/', true);
                      },
                      child: Text(
                        'Insert Link',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                        TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Theme
                                  .of(context)
                                  .accentColor),
                          onPressed: () {
                            controller.insertNetworkImage(
                                Provider.of<ChurchProvider>(context, listen: false).church.imageURL,
                                filename: 'Google network image');
                          },
                          child: Text(
                            'Insert my church image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class HtmlEditorExample extends StatefulWidget {
  HtmlEditorExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HtmlEditorExampleState createState() => _HtmlEditorExampleState();
}
