import 'package:intl/intl.dart';

class DateFormatter {
  static String formatFull(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime.toLocal());
  }

  static String formatDateOnly(DateTime dateTime) {
    return DateFormat('EEE, dd MMM yyyy', 'id_ID').format(dateTime.toLocal());
  }

  static String formatShort(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime.toLocal());
  }

  static bool isOverdue(DateTime dueDate) {
    return dueDate.isBefore(DateTime.now());
  }
}
