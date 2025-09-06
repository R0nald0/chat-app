import 'package:intl/intl.dart';

extension FormaterData on DateTime {

  String  formatedToStringDayMinute() {
     return  DateFormat('hh:mm').format(this);
  } 

}