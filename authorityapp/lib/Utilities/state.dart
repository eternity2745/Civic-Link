import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StateManagement with ChangeNotifier {
  String username = "";
  String email = "";
  String profilePic = "";
  String locality = "";
  int id = 0;
  String docID = "";

  List<Map<String, dynamic>>? mainPosts = [];
  bool mainPostsLoading = true;
  int mainPostID = 0;

  List<Map<String, dynamic>>? comments = [];
  bool commentsLoading = false;

  List<Map<String, dynamic>> progress = [{"progContent":["", "Not Started"]}];
  bool tookAction = false;
  bool isCompleted = false;
  bool isReported = false;

  void setProfile(String username, String email, String profilePic, String locality, int id, String docID) {
    this.username = username;
    this.email = email;
    this.profilePic = profilePic;
    this.locality = locality;
    this.id = id;
    this.docID = docID;
    notifyListeners();
  }

  void setPosts(List<Map<String, dynamic>>? posts) {
    mainPosts = posts;
    mainPostsLoading = false;
    notifyListeners();
  }

  void setComments(List<Map<String, dynamic>>? comments) {
    this.comments = comments;
    commentsLoading = false;
    notifyListeners();
  }

  void startAction(Timestamp time) {
    tookAction = true;
    mainPosts![mainPostID]['action'] = true;
    mainPosts![mainPostID]['progress'].add({"progContent" : [time, "Issued Order"]});
    notifyListeners();
  }

  void addProgress(Timestamp time, String content) {
    mainPosts![mainPostID]['progress'].add({"progContent" : [time, content]});
    notifyListeners();
  }

  void completed() {
    isCompleted = true;
    notifyListeners();
  }

  void reportPost() {
    isReported = true;
    notifyListeners();
  }


}