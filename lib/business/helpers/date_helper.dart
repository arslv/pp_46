import 'package:intl/intl.dart';

class DateHelper {
  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('EEE, MMM dd');
    return formatter.format(dateTime);
  }
}