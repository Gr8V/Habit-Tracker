String getDateWithMonthName() {
  final now = DateTime.now();

  final weekday = [
    "Mon","Tue","Wed","Thu","Fri","Sat","Sun"
  ][now.weekday - 1];

  final month = [
    "Jan","Feb","Mar","Apr","May","Jun",
    "Jul","Aug","Sep","Oct","Nov","Dec"
  ][now.month - 1];

  return "$weekday, ${now.day} $month";
}

String getDateWithMonthNumber() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString().padLeft(2, '0');
  final day = now.day.toString().padLeft(2, '0');
  return "$day-$month-$year";
}

String todaysDate = getDateWithMonthNumber();
