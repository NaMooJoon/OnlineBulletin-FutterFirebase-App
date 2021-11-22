import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _regionController = TextEditingController();
  TextEditingController _churchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon:Icon(Icons.close, color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pushNamed('/search');
            },
          ),
          elevation: 0.0,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '교회 찾기',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 60,),
            Container(
              width: 350,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                    controller: _regionController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '지역',
                    )
                )
              )
            ),
            const SizedBox(height: 12.0),
            Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                        controller: _churchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '교회',
                        )
                    )
                )
            ),
            SizedBox(height: 60,),
            Container(
              width: 350.0,
              height: 50,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side : BorderSide(color: Colors.black),
                ),
                child: Text("등록하기", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold,), ),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}