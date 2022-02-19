import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemoAddEditModel extends ChangeNotifier {
  String? title;
  String? contents;
  String? id;

  Future AddMemo(String? title, String? contents) async {
    this.title = title;
    this.contents = contents;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('memo')
        .add({
      'Title': this.title,
      'Contents': this.contents,
      'AtTime': DateTime.now(),
    });
  }

  Future EditMemo(String id, String? title, String? contents) async {
    this.id = id;
    this.title = title;
    this.contents = contents;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('memo')
        .doc(this.id)
        .update({
      'Title': this.title,
      'Contents': this.contents,
      'AtTime': DateTime.now(),
    });
  }
}
