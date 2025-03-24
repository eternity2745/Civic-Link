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
      var info = await database.collection("users").add(userInfo);
      return info.id;
    } catch (e) {
      return null;
    }
  }

  Future<QuerySnapshot> getUserInfo(String email) async {
    return await database.collection("users").where("email", isEqualTo: email).get();
  }

  Future createPost(Map<String, dynamic> post, String id) async {
    try {
      await database.collection("posts").add(post);
      await database.collection("users").doc(id).update({"posts" : FieldValue.increment(1)});
      return true;
    }catch(e) {
      return false;
    }
  }

  Future<QuerySnapshot> getUserPosts(int userID) async {
    return await database.collection("posts").where("userID", isEqualTo: userID).orderBy("dateTime", descending: true).get();
  }

  Future<QuerySnapshot> getMainPosts() async {
    return await database.collection("posts").orderBy("dateTime", descending: true).limit(5).get();
  }

}