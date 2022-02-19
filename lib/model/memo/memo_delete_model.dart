import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemoListMdel extends ChangeNotifier {
  String? id;

  Future DeleteMemo(String id) async {
    this.id = id;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('memo')
        .doc(this.id)
        .delete();
  }
}
