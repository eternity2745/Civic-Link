import 'package:flutter/material.dart';

class StateManagement with ChangeNotifier {

  String username = "";
  String displayname = "";
  String email = "";
  String profilePic = "";
  int ranking = 0;
  int reports = 0;
  int posts = 0;
  int id = 0;
  String docID = "";

  List<double> reportCoordinates = [];
  String reportLocality = "";
  String addressName = "";
  String reportAdministrativeArea = "";

  List<Map<String, dynamic>> userPosts = [{}];

  List<Map<String, dynamic>>? mainPosts = [{}];
  bool mainPostsLoading = true;

  void setProfile(String username, String displayname, String email, String profilePic, int ranking, int reports, int posts, int id, String docID) {
    this.username = username;
    this.displayname = displayname;
    this.email = email;
    this.profilePic = profilePic;
    this.ranking = ranking;
    this.reports = reports;
    this.posts = posts;
    this.id = id;
    this.docID = docID;
    notifyListeners();
  }

  void setReportLocationAddress(List<double> coordinates, String locality, String name, String administrativeArea) {
    reportCoordinates = coordinates;
    reportLocality = locality;
    addressName = name;
    reportAdministrativeArea = administrativeArea;
    notifyListeners();
  }

  void resetReportLocationAddress() {
    reportCoordinates.clear();
    reportLocality = "";
    addressName = "";
    reportAdministrativeArea = "";
    notifyListeners();
  }

  void setUserPosts({List<Map<String, dynamic>>? posts, Map<String, dynamic>? post}) {
    if(post != null) {
      userPosts.insert(0, post);
    }else{
      userPosts = posts!;
    }
    notifyListeners();
  }

  void setPosts(List<Map<String, dynamic>>? posts) {
    mainPosts = posts;
    mainPostsLoading = false;
    notifyListeners();
  }

}