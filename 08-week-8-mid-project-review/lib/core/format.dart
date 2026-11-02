import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('dd MMM yyyy, HH:mm');
  return formatter.format(dateTime);
}
