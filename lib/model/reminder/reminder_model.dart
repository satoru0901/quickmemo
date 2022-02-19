import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReminderModel extends ChangeNotifier {
  String? reminder;
  String? id;
  bool? isChecked;

  Future AddReminder(String? reminder) async {
    this.reminder = reminder;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('reminder')
        .add({
      'Reminder': this.reminder,
      'AtTime': DateTime.now(),
    });
  }

  Future EditReminder(String id, String? reminder) async {
    this.id = id;
    this.reminder = reminder;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('reminder')
        .doc(this.id)
        .update({
      'Reminder': this.reminder,
      'AtTime': DateTime.now(),
    });
  }

  Future DeleteReminder(String id) async {
    this.id = id;

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('reminder')
        .doc(this.id)
        .delete();
  }
}
