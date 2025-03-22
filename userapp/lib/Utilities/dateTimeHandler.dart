import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeHandler{

  static String getFormattedDate(Timestamp timestamp) {
    var format = DateFormat('y-M-d');
    return format.format(timestamp.toDate());

  }

}