import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BiblePage extends StatefulWidget {
  BiblePage({Key? key}) : super(key: key);

  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  List<bool> _selection = [true, false];
  int _firstIndex = 0;
  int _secondIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('성경',
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
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ToggleButtons(
                color: Colors.black26,
                constraints: BoxConstraints(minWidth: 175.0, minHeight: 40.0),
                children: <Widget>[
                  Text("구약", style:TextStyle(fontSize: 17, fontWeight: FontWeight.bold,), ),
                  Text("신약", style:TextStyle(fontSize: 17, fontWeight: FontWeight.bold,), ),
                ],
                onPressed: (int index) {
                  setState(() {
                    for(int i=0; i<2; i++){_selection[i] = false;}
                    _selection[index] = true;
                  });
                },
                isSelected: _selection,
                borderRadius: BorderRadius.circular(20),
                fillColor: Colors.white,
                selectedColor: Colors.green,
              ),
            ),
            const SizedBox(height: 25.0),
            Divider(thickness: 2.0,),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: _firstIndex == index ?
                                  Text("창세기", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ) :
                                  Text("창세기", style:TextStyle(fontSize: 15, color: Colors.black26), ),
                                onTap: () {
                                  setState(() {
                                    _firstIndex = index;
                                    _secondIndex = -1;
                                  });
                                },
                                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                                dense:true,
                              ),
                              Divider(thickness: 1.0,)]
                          ),
                        );
                      },
                    ),
                  ),
                  VerticalDivider( thickness: 1,),
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: 50,
                      itemBuilder: (BuildContext context, int index) {
                        int idx = index+1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                              children: [
                                ListTile(
                                  title: _secondIndex == index ?
                                  Text("$idx장", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ) :
                                  Text("$idx장", style:TextStyle(fontSize: 15, color: Colors.black26), ),
                                  onTap: () {
                                    setState(() {
                                      _secondIndex = index;
                                    });
                                    Navigator.of(context).push (
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => PlayerPage('$_firstIndex,$_secondIndex'),
                                      ),
                                    );
                                  },
                                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                                  dense:true,
                                ),
                                Divider(thickness: 1.0,)]
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class PlayerPage extends StatefulWidget {
  final String _bibleID;

  PlayerPage(this._bibleID);

  @override
  _PlayerPageState createState() => _PlayerPageState(_bibleID);
}

class _PlayerPageState extends State<PlayerPage> {
  String _bibleID;
  _PlayerPageState(this._bibleID);
  int _selectedIndex = 0;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
        YoutubePlayer.convertUrlToId
          ('https://www.youtube.com/watch?v=2-2dyh2JysM&ab_channel='
            '%EA%B3%B5%EB%8F%99%EC%B2%B4%EC%84%B1%EA%B2%BD%EC%9D%BD%EA%B8%B0')!,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: false,
        enableCaption: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('성경',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              YoutubePlayer(
                controller: _controller,
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 10.0),
                  ProgressBar(isExpanded: true),
                  const SizedBox(width: 10.0),
                  RemainingDuration(),
                  //FullScreenButton(),
                ],
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.white,
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top:10.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    int idx = index + 1;
                    return ListTile(
                      minLeadingWidth : 20,
                      leading: _selectedIndex == index ?
                      Text("$idx", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ) :
                      Text("$idx", style:TextStyle(fontSize: 15, color: Colors.black26), ),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      title: _selectedIndex == index ?
                      Text("태초에 하니님이 천지를 창조하시니라", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ) :
                      Text("태초에 하니님이 천지를 창조하시니라", style:TextStyle(fontSize: 15, color: Colors.black26), ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      dense:true,
                    );
                  },
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}