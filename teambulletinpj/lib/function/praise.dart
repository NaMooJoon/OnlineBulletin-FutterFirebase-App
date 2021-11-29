import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PraisePage extends StatefulWidget {
  PraisePage({Key? key}) : super(key: key);

  @override
  _PraisePageState createState() => _PraisePageState();
}

class _PraisePageState extends State<PraisePage> {
  TextEditingController editingController = TextEditingController();

  List<String> duplicateItems = [];
  List<String> items = [];
  int _selectedIndex = -1;
  bool _listInitialized = false;

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('hymn')
          .orderBy("rowNumber", descending: false).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return  Text('');
        }
        final documents = snapshot.data!.docs;

        duplicateItems = List<String>.generate(documents.length, (i) {
          int idx = i+1;
          return "$idx장";
        });

        if (editingController.text.isEmpty && !_listInitialized) {
          items.addAll(duplicateItems);
          _listInitialized = true;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('찬송가',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20,),
                  _selectedIndex < 0 ?
                  Container(
                      width: 350,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                          onChanged: (value) {
                            filterSearchResults(value);
                          },
                          controller: editingController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: '장',
                          )
                      )
                  ) : Container(
                      width: 350,
                      height: 50,
                      child: FlatButton(
                        color: Colors.black12,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = -1;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side : BorderSide(color: Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("$_selectedIndex장", style:TextStyle(fontSize: 15),),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ),
                      ),
                  ),
                  SizedBox(height:12.0),
                  Expanded(
                    child: _selectedIndex < 0 ?
                    ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  Text('${items[index]}'),
                                  SizedBox(width:30),
                                  Text('${documents[index]['title']}'),
                                ],
                              ),
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                }
                            ),
                            Divider(),
                          ],
                        );
                      }
                    ) : Image.network(documents[_selectedIndex]['imageURL']),
                  ),
                ],
              ),
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      }
    );
  }
}