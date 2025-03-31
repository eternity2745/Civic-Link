import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
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

  Future addComment(Map<String, dynamic> comment, String postID) async {
    try{
      await database.collection("posts").doc(postID).collection("comments").add(comment);
      await database.collection("posts").doc(postID).update({"comments":FieldValue.increment(1)});
      return true;
    }catch(e){
      return false;
    }
  }

  Future<QuerySnapshot> getComments(String postID) async {
    return await database.collection("posts").doc(postID).collection("comments").orderBy("dateTime", descending: true).limit(5).get();
  }

  Future addLike(String postID, int userID) async {
    try{
      await database.collection("posts").doc(postID).update({"likes":FieldValue.increment(1), "likesId":FieldValue.arrayUnion([userID])});
      return true;
    }catch(e) {
      return false;
    }
  }

  Future removeLike(String postID, int userID) async {
    try{
      await database.collection("posts").doc(postID).update({"likes":FieldValue.increment(-1), "likesId":FieldValue.arrayRemove([userID])});
      return true;
    }catch(e) {
      return false;
    }
  }

  Future<QuerySnapshot> getLocalityPosts(String locality) async {
    return await database.collection("posts").where("locality", isEqualTo: locality).orderBy("dateTime", descending: true).limit(5).get();
  }

  Future<Object?> getNearLocationPosts(double latitude, double longitude) async {

    GeoFirePoint geo = GeoFirePoint(GeoPoint(latitude, longitude));
    GeoPoint geopointFrom(Map<String, dynamic> data) {
     return data['location'] as GeoPoint;
    }
    final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> result =
    GeoCollectionReference<Map<String, dynamic>>(database.collection("posts"))
        .subscribeWithin(
              center: geo,
              radiusInKm: 20,
              field: "location",
              geopointFrom: geopointFrom,
            );
    // return await GeoCollectionReference(collectionReference)
    Object? data;
    result.listen((List<DocumentSnapshot> event) {
      int length = event.length;
      log("$length");
      log("$event");
      for (int i = 0; i < length; i++) {
        data = event[i].data();
        // Process the data as needed
      }
      log("$data");
    });
    return data;
  }

}