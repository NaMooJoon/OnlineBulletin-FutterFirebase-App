import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/function/eachcomment.dart';
import 'package:shrine/provider/churchProvider.dart';
import 'package:shrine/provider/login_provider.dart';

import 'commentstruct.dart';

class CommentPage extends StatefulWidget {
  final String docid;
  final String userimg;
  final String content;
  final String username;
  const CommentPage(
      {Key? key,
      required this.docid,
      required this.userimg,
      required this.content,
      required this.username})
      : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {

  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Comments> comment = [];
  @override
  Widget build(BuildContext context) {
    final churchprovider = Provider.of<ChurchProvider>(context, listen:false);
    // TODO: implement build
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('church').doc(churchprovider.church.id)
          .collection('infostory')
          .doc(widget.docid)
          .collection('comment').orderBy("updatetime",descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
          comment = snapshot.data!.docs.map<Comments>((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Comments(
                docid: widget.docid,
                commentid: document.id,
                uid: data['uid'],
                username: data['user'],
                updatetime: " ",
                //DateFormat('yyyy-MM-dd HH:mm').format(DateTime.fromMicrosecondsSinceEpoch(data['updatetime'].microsecondsSinceEpoch)).toString(),
                content: data['content'],
                userimgUrl: data['userimgUrl'],
              );
          }).toList();
          return Scaffold(
              appBar: AppBar(
                                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0.0,
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  '댓글',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              body: Column(
                children: [
                  Flexible(
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            _CommentHeader(
                                userimg: widget.userimg,
                                content: widget.content,
                                username: widget.username)
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Divider(
                            endIndent: 10,
                            indent: 10,
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                        ),
                        ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final Comments comments = comment[index];
                            return CommentsContainer(comments: comments);
                          },
                          itemCount: comment.length,
                        ),
                      ],
                    ),
                  ),
                  _buildTextComposer(docid: widget.docid),
                ],
              ));
        }
    );
  }

}
class _buildTextComposer extends StatefulWidget{
  final String docid;
  const _buildTextComposer({Key? key, required this.docid}) : super(key: key);
  @override
  __buildTextComposerState createState() => __buildTextComposerState();
}

class __buildTextComposerState extends State<_buildTextComposer> {
  bool isComposing = false;
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    isComposing = text.isNotEmpty;
                  }); // NEWNEW
                },
                onSubmitted:
                isComposing ? _handleSubmitted : null,
                decoration:
                const InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.android
                    ? CupertinoButton(
                  // NEW
                  child: Icon(Icons.send) ,// NEW
                  onPressed: isComposing // NEW
                      ? ()  =>
                       _handleSubmitted(_textController.text) // NEW
                      : null,
                )
                    : IconButton(
                  icon: Icon(Icons.send) ,
                  onPressed: isComposing // MODIFIED
                      ? () =>  _handleSubmitted(
                      _textController.text) // MODIFIED
                      : null, // MODIFIED
                )),
          ],
        ),
      ),
    );
  }
  Future _handleSubmitted(String text) async {
    setState(() {
      isComposing = false;
    });
    final churchprovider = Provider.of<ChurchProvider>(context, listen:false);
    final loginprovider = Provider.of<LoginProvider>(context, listen: false);
    /*Comments com = Comments(
      username: loginprovider.user.displayName.toString(),
      userimgUrl: loginprovider.user.photoURL.toString(),
      content: _textController.text,
      updatetime: FieldValue.serverTimestamp().toString(),
    );*/
    try {
      await FirebaseFirestore.instance.collection('church').doc(churchprovider.church.id)
          .collection('infostory')
          .doc(widget.docid)
          .collection('comment')
          .add({
        'uid': loginprovider.user.uid,
        'user': loginprovider.user.displayName,
        'updatetime': FieldValue.serverTimestamp(),
        'userimgUrl': loginprovider.user.photoURL,
        'content': _textController.text,
      });
    } catch (e) {
      print(e);
    }
    _textController.clear();
    //commentingprovider.notcommenting();
    _focusNode.requestFocus(); //NEW
  }
}
class _CommentHeader extends StatelessWidget {
  final String userimg;
  final String content;
  final String username;
  const _CommentHeader(
      {Key? key,
      required this.userimg,
      required this.content,
      required this.username})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatar(imageUrl: userimg),
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 3),
              ],
            )
          ],
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const SizedBox(width: 3),
                  Expanded(child: Text(content)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  const ProfileAvatar({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.0,
      backgroundColor: Colors.grey[600],
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}
