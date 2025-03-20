import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:random_string/random_string.dart';

class DatabaseMethods {

  FirebaseFirestore database = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential credential;

  Future signUp(String email, String password) async {
    try {
      credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      // await auth.currentUser?.sendEmailVerification();
      return true;
    } catch(e) {
      return false;
    }
  }

  Future signIn(String email, String password) async {
    try {
      credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future addUserInfo(Map<String, dynamic> userInfo) async {
    try {
      log("Adding");
      await database.collection("users").add(userInfo);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<QuerySnapshot> getUserInfo(String email) async {
    return await database.collection("users").where("email", isEqualTo: email).get();
  }

  Future createPost(Map<String, dynamic> post) async {
    try {
      await database.collection("posts").add(post);
      return true;
    }catch(e) {
      return false;
    }
  }
}