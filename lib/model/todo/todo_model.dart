import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TodoModel extends ChangeNotifier {
  String? list;
  String? id;
  bool? isChecked;

  Future AddList(String? list) async {
    this.list = list;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('list')
        .add({
      'List': this.list,
      'AtTime': DateTime.now(),
      'isChecked': false,
    });
  }

  Future EditList(String id, String? list) async {
    this.id = id;
    this.list = list;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('list')
        .doc(this.id)
        .update({
      'List': this.list,
      'AtTime': DateTime.now(),
    });
  }

  Future CheckList(String id, bool? isChecked) async {
    this.id = id;
    this.isChecked = isChecked;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('list')
        .doc(this.id)
        .update({
      'isChecked': isChecked,
    });
  }

  Future DeleteList(String id) async {
    this.id = id;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('list')
        .doc(this.id)
        .delete();
  }

  DeleteCheckedList() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('list')
        .where("isChecked", isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((deleteContents) {
        deleteContents.reference.delete();
      });
    });
  }
}
