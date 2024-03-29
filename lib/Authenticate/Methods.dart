import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'LoginScree.dart';

Future<User?> createAccount(
    String name, String email, String password, String phone) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created Succesfull");

    userCrendetial.user!.updateDisplayName(name);

    await _firestore
        .collection('Raw_students_info')
        .doc(_auth.currentUser!.uid)
        .set({
      "name": name,
      "email": email,
      "phone no": phone,
      "uid": _auth.currentUser!.uid,
    });

    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> createAccountForAdmission(
    String name, String email, String password, String phone) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created on Admission section Succesfull");

    userCrendetial.user!.updateDisplayName(name);

    await _firestore
        .collection('New_Admission_Request')
        .doc(_auth.currentUser!.uid)
        .set({
      'full name': name,
      'Phone No': phone,
      'email': phone,
      'isAdmissionDone': false,
      'role': 'For Admission',
      "admission - section": true
    });

    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future resetPassword(String email) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.sendPasswordResetEmail(email: email);
    print("Link Sent Succesfully");
    Get.snackbar("Link sent sucessfully", "check your email!");
  } catch (e) {
    print(e);
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    print("Login Sucessfull");
    _firestore
        .collection('Raw_students_info')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) =>
            userCredential.user!.updateDisplayName(value['full name']));

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logInAdmission(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    print("Login Sucessfull");
    _firestore
        .collection('New_Admission_Request')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) =>
            userCredential.user!.updateDisplayName(value['full name']));

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  } catch (e) {
    print("error${e.toString()}");
  }
}
