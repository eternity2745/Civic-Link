// import 'dart:developer';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
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
    List finalResult = [];
    try {
      QuerySnapshot result = await database.collection("authorities").where("email", isEqualTo: email).where("password", isEqualTo: password).get();
      if(result.docs.isNotEmpty) {
        finalResult.add(result.docs[0]);
        finalResult.add(result.docs[0].id);
      }
      return finalResult;
    } catch(e) {
      return finalResult;
    }
  }

  Future getUserInfo(String email, String password) async {
    try {
      credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<QuerySnapshot> getMainPosts(String locality) async {
    return await database.collection("posts").where("locality", isEqualTo: locality).where("completed", isEqualTo: false).orderBy("dateTime", descending: true).limit(5).get();
  }

  Future<QuerySnapshot> getComments(String postID) async {
    return await database.collection("posts").doc(postID).collection("comments").orderBy("dateTime", descending: true).limit(5).get();
  }

  Future startAction(String postID, Timestamp time) async {
    try{
      log("Starting action");
      await database.collection("posts").doc(postID).update({"action" : true, "progress" : FieldValue.arrayUnion([{"progContent":[time, "Issued Order"]}])});
      return true;
    }catch(e) {
      return false;
    }
  }

  Future addProgress(String postID, Timestamp time, String content) async {
    try{
      await database.collection("posts").doc(postID).update({"progress" : FieldValue.arrayUnion([{"progContent":[time, content]}])});
      return true;
    }catch(e) {
      return false;
    }
  }

  Future completed(String postID, Timestamp time) async {
    try{
      log("Starting action");
      await database.collection("posts").doc(postID).update({"completed" : true, "progress" : FieldValue.arrayUnion([{"progContent":[time, "Completed"]}])});
      return true;
    }catch(e) {
      return false;
    }
  }

}