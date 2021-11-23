import 'package:flutter/material.dart';

class PraisePage extends StatefulWidget {
  PraisePage({Key? key}) : super(key: key);

  @override
  _PraisePageState createState() => _PraisePageState();
}

class _PraisePageState extends State<PraisePage> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) {
    int idx = i+1;
    return "$idx장";
  });

  List<String> items = [];
  int _selectedIndex = -1;

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
                          Text("377장", style:TextStyle(fontSize: 15),),
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
                          title: Text('${items[index]}'),
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
                ) : Image.network('https://t1.daumcdn.net/cfile/blog/995C953B5DD77A612A'),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}