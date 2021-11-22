import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PageViewer extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Church pageviewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChurchPages(),
    );
  }
}

class ChurchPages extends StatefulWidget {
  ChurchPages({Key? key}) : super(key: key);

  @override
  _ChurchPageState createState() => _ChurchPageState();
}

class _ChurchPageState extends State<ChurchPages> {

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(FontAwesomeIcons.church),
          title: new Text('Red'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(FontAwesomeIcons.bookOpen),
        title: new Text('Blue'),
      ),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.thLarge),
          title: Text('Yellow')
      ),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.bible),
          title: Text('asdfa')
      ),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.itunesNote),
          title: Text('sdfow')
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Red(),
        Blue(),
        Yellow(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: Color.fromRGBO(186, 186, 186, 1.0),
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: Colors.red,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.yellow))),
        child: BottomNavigationBar(
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
      ),
    );
  }
}



class Red extends StatefulWidget {
  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Red> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RED"),),
      body: Container(
        color: Colors.red,
      ),
    );
  }
}

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BLUE"),),
      body: Container(
        color: Colors.blueAccent,
      ),
    );
  }
}

class Yellow extends StatefulWidget {
  @override
  _YellowState createState() => _YellowState();
}

class _YellowState extends State<Yellow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YELLO"),),
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}