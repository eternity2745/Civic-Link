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

  List<double> reportCoordinates = [];
  String reportLocality = "";

  void setProfile(String username, String displayname, String email, String profilePic, int ranking, int reports, int posts, int id) {
    this.username = username;
    this.displayname = displayname;
    this.email = email;
    this.profilePic = profilePic;
    this.ranking = ranking;
    this.reports = reports;
    this.posts = posts;
    this.id = id;
    notifyListeners();
  }

  void setReportLocationAddress(List<double> coordinates, String locality) {
    reportCoordinates = coordinates;
    reportLocality = locality;
    notifyListeners();
  }

}