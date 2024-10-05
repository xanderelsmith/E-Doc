import 'package:intl/intl.dart';

extension DateFormatter on DateTime {
  String get greeting => hour < 12
      ? "Good morning"
      : DateTime.now().hour < 17
          ? "Good afternoon"
          : 'Good Evening';
  String toTomorrowFormat() {
    final now = DateTime.now();

    var daydiff = (day - now.day);
    if (year == now.year && month == now.month && day == now.day + 1) {
      return 'Tomorrow, ${DateFormat('MMM d').format(this)}.';
    } else if (day > now.day || daydiff > 1) {
      return 'in $daydiff days, ${DateFormat('MMM d').format(this)}.';
    } else {
      return DateFormat('MMM d').format(this);
    }
  }
}
