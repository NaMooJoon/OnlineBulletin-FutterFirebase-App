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
        leading: IconButton(
          icon:Icon(Icons.menu, color: Colors.black,),
          onPressed: () {},
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        title: Text('교회 이름',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 80.0),
            Image.network(
              'https://mblogthumb-phinf.pstatic.net/20160616_243/yn1984_1466081798536CjTlr_JPEG/2.jpg?type=w2',
              width: 420,
              height: 200,
              fit: BoxFit.fill,
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
                    child: Stack(
                      children: [Image.network(
                        'https://p1.pikrepo.com/preview/870/131/closed-black-hardbound-bible-on-gray-surface.jpg',
                        width: 130,
                        height: 170,
                        fit: BoxFit.cover,
                      ),
                      ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        'https://blog.kakaocdn.net/dn/yGLRf/btreJDXvtHf/S3ABLZhkWQZefzBhVvkFL0/img.jpg',
                        width: 130,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        'https://post-phinf.pstatic.net/MjAxODA2MjhfMjk1/MDAxNTMwMTcwMDQ5MTU1.H701CvX4KbT2IYoZ7VTk9b_gAZCKLY41E_kKtVNPw9sg.9YsiPus1e3_szlHCc2iu47v0ph1dvmtN4XqyQgIVRjAg.JPEG/photo-1515162305285-0293e4767cc2.jpg?type=w1200',
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        'https://c.pxhere.com/photos/2f/54/audience_band_concert_crowd_hands_lights_live_performance_music-934152.jpg!d',
                        width: 130,
                        height: 150,
                        fit: BoxFit.cover,
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