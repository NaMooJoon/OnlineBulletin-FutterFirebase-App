import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
      body: FutureBuilder<QuerySnapshot>(
          future:  FirebaseFirestore.instance.collection('bible')
              .orderBy("rowNumber", descending: false).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return  Text('');
            }
            final documents = snapshot.data!.docs;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10,),
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
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                  children: [
                                    ListTile(
                                      title: _firstIndex == index ?
                                      Text(documents[index]['chapterName'], style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ) :
                                      Text(documents[index]['chapterName'], style:TextStyle(fontSize: 15, color: Colors.black26), ),
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
                          itemCount: documents[_firstIndex]['chapterNum'],
                          itemBuilder: (BuildContext context, int index) {
                            int idx = index+1;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: _secondIndex == index ?
                                      Text("$idx장", style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ) :
                                      Text("$idx장", style:TextStyle(fontSize: 15, color: Colors.black26), ),
                                      onTap: () {
                                        setState(() {
                                          _secondIndex = index;
                                        });
                                        /*  // 오류 방지를 위해 //
                                        int chapter = _secondIndex + 1;
                                        String chapterName = documents[_firstIndex]['chapterName'];
                                        */
                                        int chapter = 1;
                                        String chapterName = 'Genesis';
                                        Navigator.of(context).push (
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => PlayerPage(chapterName, chapter),
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
          );
        }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class PlayerPage extends StatefulWidget {
  final String chapterName;
  final int chapter;

  PlayerPage(this.chapterName, this.chapter);

  @override
  _PlayerPageState createState() => _PlayerPageState(chapterName, chapter);
}

class _PlayerPageState extends State<PlayerPage> {
  String chapterName;
  int chapter;
  _PlayerPageState(this.chapterName, this.chapter);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('bible').doc(chapterName)
              .collection('CH$chapter').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return  Text('');
        }
        final documents = snapshot.data!.docs;

        YoutubePlayerController _controller =YoutubePlayerController(
          initialVideoId:
          YoutubePlayer.convertUrlToId(documents[chapter-1]['videoURL'])!,
          flags: YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: true,
            loop: false,
            enableCaption: false,
          ),
        );

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
                          Text(documents[chapter-1]['verse'][index], style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ) :
                          Text(documents[chapter-1]['verse'][index], style:TextStyle(fontSize: 15, color: Colors.black26), ),
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
    );
  }
}