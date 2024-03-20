import 'package:intl/intl.dart';

  extension DateTimeData on DateTime {
  String get yearMonthDay {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}

extension DateTimeStringData on String {
  DateTime toDateTime() {
    return DateFormat('dd/MM/yyyy').parse(this);
  }
}
