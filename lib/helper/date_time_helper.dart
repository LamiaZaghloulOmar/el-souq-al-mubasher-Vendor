import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy - hh:mm a').format(dateTime);
  }
}
