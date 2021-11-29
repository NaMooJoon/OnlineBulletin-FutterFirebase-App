import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Church.dart';
import 'provider/login_provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();
  FirebaseFirestore _database = FirebaseFirestore.instance;
  List<Church> _allChurchList = [];
  List<Church> items = [];
  bool _listInitialized = false;

  Future<void> updateMemberList(String cid, List<String> newList) {
    DocumentReference ref = _database.collection("church").doc(cid);
    return ref.update({
      'memberList': newList,
    });
  }

  @override
  void initState() {
    items.addAll(_allChurchList);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<Church> dummySearchList = [];
    dummySearchList.addAll(_allChurchList);
    if(query.isNotEmpty) {
      List<Church> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.toString().contains(query)) {
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
        items.addAll(_allChurchList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _database.collection("church")
              .orderBy("createdAt", descending: false)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if(!snapshot.hasData) {
          return const Text('');
        }
        _allChurchList = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return Church(
            id: document.id,
            churchName: data['churchName'],
            location: data['location'],
            callNumber: data['callNumber'],
            imageURL: data['imageURL'],
            master: data['master'],
            pastor: data['pastor'],
            memberList: data['memberList']?.cast<String>(),
          );
        }).toList();

        if(editingController.text.isEmpty && !_listInitialized) {
          items.addAll(_allChurchList);
          _listInitialized = true;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('교회 찾기',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text(
                  '교회 등록',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),
                ),
                textColor: Colors.green,
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                          onChanged: (value) {
                            filterSearchResults(value);
                            print(value);
                          },
                          controller: editingController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: '교회 이름',
                          )
                      )
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '최근 등록된 교회',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height:12.0),
                Divider(),
                Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0.0),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile (
                                contentPadding: EdgeInsets.all(0.0),
                                leading: Image.network(
                                  items[index].imageURL,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items[index].churchName,
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      items[index].location,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: new IconButton(
                                  icon: new Icon(Icons.add_box_outlined, color: Colors.green,),
                                  onPressed: () async {
                                    var snackBar = const SnackBar(content: Text('해당 교회가 추가되었습니다!'));
                                    List<String> newMemberList =  items[index].memberList;
                                    final provider = Provider.of<LoginProvider>(context, listen: false);

                                    if(!(newMemberList.contains(provider.user.uid))) {
                                      provider.updateChurchData(items[index].id);

                                      newMemberList.add(provider.user.uid);
                                      await updateMemberList(items[index].id, newMemberList);
                                    } else {
                                      snackBar = const SnackBar(content: Text('이미 리스트에 포함된 교회입니다'));
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                ),
                              ),
                              Divider(),
                            ],
                          );
                        }
                    ),
                ),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      }
    );
  }
}
