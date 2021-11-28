import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      onChanged: (value) {},
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
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile (
                            contentPadding: EdgeInsets.all(0.0),
                            leading: Image.network(
                              'https://mblogthumb-phinf.pstatic.net/20160616_243/yn1984_1466081798536CjTlr_JPEG/2.jpg?type=w2',
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '한동대학교 효암관',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '포항시 북구 흥해읍 한동로 558',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color:Colors.black12),
                                ),
                              ],
                            ),
                            trailing: new IconButton(
                              icon: new Icon(Icons.add_box_outlined, color: Colors.green,),
                              onPressed: () {},
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
}
