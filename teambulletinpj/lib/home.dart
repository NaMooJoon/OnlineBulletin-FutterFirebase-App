import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/pageviewer.dart';
import 'package:shrine/provider/churchProvider.dart';

import 'Church.dart';
import 'provider/login_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Church> _churchList = [];
  List<String> _existList = [];
  bool _showChurchList = false;
  int _selectedChurch = 0;

  Future<void> updateMemberList(String cid, List<String> newList) {
    DocumentReference ref = FirebaseFirestore.instance.collection("church").doc(cid);
    return ref.update({
      'memberList': newList,
    });
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream:  FirebaseFirestore.instance.collection('church').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if(!snapshot.hasData) {
          return const Text('');
        }

        final provider = Provider.of<LoginProvider>(context, listen: false);
        List<String> churchIdList = provider.churchList;

        for(String churchId in churchIdList) {
          for (DocumentSnapshot document in snapshot.data!.docs) {
            if (churchId == document.id && !(_existList.contains(churchId))) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              _churchList.add(
                  Church(
                    id: document.id,
                    churchName: data['churchName'],
                    location: data['location'],
                    callNumber: data['callNumber'],
                    imageURL: data['imageURL'],
                    master: data['master'],
                    pastor: data['pastor'],
                    memberList: data['memberList']?.cast<String>(),
                  ));
              _existList.add(churchId);
              break;
            }
          }
        }


        if(_churchList.length == 0) {
          return NoChurch();
        } else {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(_churchList[_selectedChurch].churchName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ),
            drawer: Drawer (
                child: Consumer<LoginProvider>(
                  builder: (context, loginState, _) => ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          height: 260,
                          child: DrawerHeader(
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(loginState.user.photoURL!),
                                  SizedBox(height:24.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          loginState.user.displayName!,
                                          style: TextStyle(color: Colors.white, fontSize: 28.0, fontWeight: FontWeight.bold)
                                      ),
                                      SizedBox(width:8),
                                      Text(
                                          '님',
                                          style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal:30),
                          title: const Text('내 교회 리스트',),
                          onTap: () {
                            setState(() {
                              _showChurchList = !_showChurchList;
                            });
                          },
                          leading: const Icon(Icons.playlist_add_check, color: Colors.green),
                          trailing: _showChurchList ?
                          Icon(Icons.arrow_drop_up, color: Colors.green) :
                          Icon(Icons.arrow_drop_down, color: Colors.green),
                        ),
                        _showChurchList ?
                        ListView.builder(
                            padding: const EdgeInsets.all(0.0),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _churchList.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: UniqueKey(),
                                child: ListTile(
                                    contentPadding: const EdgeInsets.only(left:60),
                                    title: Text(
                                      _churchList[index].churchName,
                                      style: _selectedChurch == index ?
                                      TextStyle(color:Colors.green,fontWeight: FontWeight.bold) :
                                      TextStyle(color:Colors.grey),
                                    ),
                                    onTap: () {
                                      final churchState = Provider.of<ChurchProvider>(context, listen: false);
                                      churchState.setChurchData(_churchList[index]);
                                      setState(() {
                                        _selectedChurch = index;
                                      });
                                      Navigator.pop(context);
                                    }
                                ),
                                background: Container(color:Colors.green),
                                onDismissed: (direction) async {
                                  String cid = _churchList[index].id;
                                  List<String> newMemberList = _churchList[index].memberList;
                                  newMemberList.removeWhere((member) => member == loginState.user.uid);
                                  await updateMemberList(cid, newMemberList);
                                  loginState.updateChurchData(cid, true);

                                  setState(() {
                                    _churchList.removeAt(index);
                                    _existList.removeAt(index);

                                    if (_churchList.length != 0) {
                                      final churchState = Provider.of<ChurchProvider>(context, listen: false);
                                      _selectedChurch = 0;
                                      churchState.setChurchData(_churchList[_selectedChurch]);
                                    }
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('해당 교회가 리스트에서 제외되었습니다!')));
                                  Navigator.pop(context);
                                },
                              );
                            }
                        ) : SizedBox(),
                        ListTile(
                          contentPadding: const EdgeInsets.only(left:30),
                          title: const Text('교회 추가하기',),
                          onTap: () {
                            Navigator.pushNamed(context, '/search');
                          },
                          leading: const Icon(Icons.playlist_add, color: Colors.green),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.only(left:30),
                          title: const Text('로그아웃',),
                          onTap: () {
                            loginState.signOut();
                            Navigator.pushNamed(context, '/login');
                          },
                          leading: const Icon(Icons.logout, color: Colors.green),
                        ),
                      ]
                  ),
                )
            ),
            body: Consumer<ChurchProvider>(
              builder: (context, churchState, _) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 80.0),
                      Stack(
                          children: [Image.network(
                            _churchList[_selectedChurch].imageURL,
                            width: 420,
                            height: 200,
                            fit: BoxFit.fill,
                          ), Positioned(
                            top: 10,
                            right: 10,
                            child: Text( '클릭하여 교회 정보 알아보기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),
                          ), Positioned.fill(
                              child : Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      churchState.setChurchData(_churchList[_selectedChurch]);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PageViewer(initialPage: 2)),
                                      );
                                    },
                                  )
                              )
                          ),]
                      ),
                      const SizedBox(height: 20.0),
                      Text('환영합니다', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 20.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Stack(
                                      children: [Image.network(
                                        'https://p1.pikrepo.com/preview/870/131/closed-black-hardbound-bible-on-gray-surface.jpg',
                                        width: 130,
                                        height: 170,
                                        fit: BoxFit.cover,
                                      ),Positioned.fill(
                                          child : Material(color: Colors.black.withOpacity(0.3),)
                                      ),Positioned(
                                        bottom: 62,
                                        left: 42,
                                        child: Text( '성경', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),),
                                      ),Positioned.fill(
                                          child : Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  churchState.setChurchData(_churchList[_selectedChurch]);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PageViewer(initialPage: 3,)),
                                                  );
                                                },
                                              )
                                          )
                                      ),]
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Stack(
                                      children: [Image.network(
                                        'https://blog.kakaocdn.net/dn/yGLRf/btreJDXvtHf/S3ABLZhkWQZefzBhVvkFL0/img.jpg',
                                        width: 130,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),Positioned.fill(
                                          child : Material(color: Colors.black.withOpacity(0.3),)
                                      ),Positioned(
                                        bottom: 37,
                                        left: 42,
                                        child: Text( '주보', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),),
                                      ),Positioned.fill(
                                          child : Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  churchState.setChurchData(_churchList[_selectedChurch]);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PageViewer(initialPage: 1,)),
                                                  );
                                                },
                                              )
                                          )
                                      ),]
                                  ),
                                ),
                              ),
                            ]),
                            Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Stack(
                                      children: [Image.network(
                                        'https://post-phinf.pstatic.net/MjAxODA2MjhfMjk1/MDAxNTMwMTcwMDQ5MTU1.H701CvX4KbT2IYoZ7VTk9b_gAZCKLY41E_kKtVNPw9sg.9YsiPus1e3_szlHCc2iu47v0ph1dvmtN4XqyQgIVRjAg.JPEG/photo-1515162305285-0293e4767cc2.jpg?type=w1200',
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),Positioned.fill(
                                          child : Material(color: Colors.black.withOpacity(0.3),)
                                      ),Positioned(
                                        bottom: 50,
                                        left: 23,
                                        child: Text( '교회 소식', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                                      ),Positioned.fill(
                                          child : Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  churchState.setChurchData(_churchList[_selectedChurch]);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PageViewer(initialPage: 0,)),
                                                  );
                                                },
                                              )
                                          )
                                      ),
                                      ]
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Stack(
                                      children: [Image.network(
                                        'https://c.pxhere.com/photos/2f/54/audience_band_concert_crowd_hands_lights_live_performance_music-934152.jpg!d',
                                        width: 130,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),Positioned.fill(
                                          child : Material(color: Colors.black.withOpacity(0.3),)
                                      ),Positioned(
                                        bottom: 57,
                                        left: 42,
                                        child: Text( '찬송', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),),
                                      ),Positioned.fill(
                                          child : Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  churchState.setChurchData(_churchList[_selectedChurch]);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => PageViewer(initialPage: 4,)),
                                                  );
                                                },
                                              )
                                          )
                                      ),]
                                  ),
                                ),
                              ),
                            ]),
                          ]
                      ),
                    ],
                  ),
                );
              }
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        }
      }
    );
  }
}

class NoChurch extends StatelessWidget {
  NoChurch({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '등록된 교회가 없습니다',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
            ),
            SizedBox(height: 60,),
            Stack(
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    height: 200.0,
                    width: 200.0,
                  ),
                  SizedBox(child:
                  Icon(CupertinoIcons.exclamationmark, size: 100.0, color: Colors.green),
                    height: 200.0,
                    width: 200.0,
                  )
                ]
            ),
            SizedBox(height: 60,),
            Container(
              width: 350.0,
              height: 50,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/search');
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side : BorderSide(color: Colors.black),
                ),
                child: Text("교회 찾기", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold,), ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}