import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/function/comment.dart';
import 'package:shrine/function/storystruct.dart';
import 'package:shrine/provider/churchProvider.dart';
import 'package:shrine/provider/like_provider.dart';
import 'package:shrine/provider/login_provider.dart';

import 'commentstruct.dart';

class CommentsContainer extends StatelessWidget {
  final Comments comments;

  const CommentsContainer({Key? key, required this.comments}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CommentsHeader(post: comments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsHeader extends StatelessWidget {
  final Comments post;
  const _CommentsHeader({Key? key, required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final churchprovider = Provider.of<ChurchProvider>(context,listen: false);
    final loginprovider = Provider.of<LoginProvider>(context,listen: false);
    return Row(
      children: [
        ProfileAvatar(imageUrl: post.userimgUrl),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.username,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(post.content),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                post.updatetime,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
        if(post.uid == loginprovider.user.uid)...[
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('church').doc(churchprovider.church.id).collection('infostory').doc(post.docid).collection('comment').doc(post.commentid).delete();
                  },
                  icon: Icon(Icons.delete))
            ],
          )
        ]
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