import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
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
                  Navigator.of(context).pushNamed('/register');
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
