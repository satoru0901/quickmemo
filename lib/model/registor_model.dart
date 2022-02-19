import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistorModel extends ChangeNotifier {
  String? email;

  Future Registor(String email) async {
    this.email = email;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: "satoru0901");
      final user = userCredential.user;
      if (user != null) {
        final uid = user.uid;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'DT': DateTime.now(),
        });
      }
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        throw ("有効なメールアドレスを入力してください");
      }
      if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        throw ("既に登録済みのメールアドレスです\nログインページへ移動してください");
      }
      throw (e.toString());
    }
  }

  Future Login(String email) async {
    this.email = email;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: "satoru0901");
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
        throw ("登録済みのメールアドレスを入力してください");
      } else if (e.toString() ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        throw ("登録済みのメールアドレスを入力してください");
      } else {
        throw (e.toString());
      }
    }
  }
}
