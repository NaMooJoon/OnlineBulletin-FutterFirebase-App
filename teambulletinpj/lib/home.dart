import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('교회 이름',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
      ),
      drawer: Drawer (
          child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  padding: EdgeInsets.only(top:100, left:30),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                      'Pages',
                      style: TextStyle(color: Colors.white, fontSize: 28.0)
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left:30),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  leading: const Icon(Icons.home, color: Colors.blue),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left:30),
                  title: const Text(
                    'Search',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  leading: const Icon(Icons.search, color: Colors.blue),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.only(left:30),
                  title: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  leading: const Icon(Icons.logout, color: Colors.blue),
                ),
              ]
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 80.0),
            Stack(
                children: [Image.network(
                  'https://mblogthumb-phinf.pstatic.net/20160616_243/yn1984_1466081798536CjTlr_JPEG/2.jpg?type=w2',
                  width: 420,
                  height: 200,
                  fit: BoxFit.fill,
                ), Positioned(
                  top: 10,
                  right: 10,
                  child: Text( '클릭 시 자세히 알아보기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),
                ), Positioned.fill(
                    child : Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () { Navigator.of(context).pushNamed('/pageviewer'); },
                        )
                    )
                ),]
            ),
            const SizedBox(height: 20.0),
            Text('환영합니다', style: TextStyle(fontSize: 17.0,),),
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
                                      onTap: () {},
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
                                      onTap: () {},
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
                              child: Text( '교회 정보', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                            ),Positioned.fill(
                                child : Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
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
                                      onTap: () {},
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}