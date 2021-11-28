import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'function/bulletin.dart';
import 'function/praise.dart';
import 'function/bible.dart';
import 'function/information.dart';
import 'function/story.dart';

class PageViewer extends StatefulWidget {
  PageViewer({Key? key, required this.initialPage}) : super(key: key);

  final int initialPage;

  @override
  _PageViewerState createState() => _PageViewerState();
}

class _PageViewerState extends State<PageViewer> {

  late int _bottomSelectedIndex;
  late PageController _pageController;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(FontAwesomeIcons.camera),
          title: new Text('Story'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(FontAwesomeIcons.bookOpen),
        title: new Text('Bulletin'),
      ),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.church),
          title: Text('Inform')
      ),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.bible),
          title: Text('Bible')
      ),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.itunesNote),
          title: Text('Hymn')
      ),
    ];
  }

  Widget buildPageView() {
    _pageController = PageController(
      initialPage: widget.initialPage,
      keepPage: true,
    );

    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        StoryPage(),
        BulletinPage(),
        InformationPage(),
        BiblePage(),
        PraisePage(),
      ],
    );
  }

  @override
  void initState() {
    _bottomSelectedIndex = widget.initialPage;
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            indicatorColor: Colors.green.shade100,
            // canvasColor: Color.fromRGBO(186, 186, 186, 1.0),
            primaryColor: Colors.red,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.yellow))),
        child: SizedBox(
          height: 50,
          child: BottomNavigationBar(
            unselectedItemColor: Colors.black45,
            selectedItemColor: Colors.green,
            currentIndex: _bottomSelectedIndex,
            iconSize: 20,
            onTap: (index) {
              bottomTapped(index);
            },
            items: buildBottomNavBarItems(),
          ),
        ),
      ),
    );
  }
}