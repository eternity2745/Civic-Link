import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeHandler{

  static String getFormattedDate(Timestamp timestamp) {
    var format = DateFormat('dd/MM/yy');
    return format.format(timestamp.toDate());
  }

  static String getFormattedTime(Timestamp timestamp) {
    var format = DateFormat('hh:mm a');
    return format.format(timestamp.toDate());
  }

}