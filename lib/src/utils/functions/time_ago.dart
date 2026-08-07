import 'package:get/get.dart';
import 'package:intl/intl.dart';

String calculateTimeAgo(String dateString) {
  // Parse the date string into a DateTime object
  DateTime inputDate = DateFormat('dd-MM-yyyy').parse(dateString);

  // Calculate the difference between the input date and the current date
  Duration diff = DateTime.now().difference(inputDate);

  // Return the formatted time ago string
  return timeAgoFormat(diff);
}

// Helper function to format the duration into a human-readable string
String timeAgoFormat(Duration duration) {
  int seconds = duration.inSeconds;

  if (seconds < 60) {
    return 'time_ago_seconds'.trParams({'count': '$seconds'});
  } else if (seconds >= 60 && seconds < 3600) {
    final minutes = (seconds / 60).round();
    return 'time_ago_minutes'.trParams({'count': '$minutes'});
  } else if (seconds >= 3600 && seconds < 86400) {
    final hours = (seconds / 3600).round();
    return 'time_ago_hours'.trParams({'count': '$hours'});
  } else if (seconds >= 86400 && seconds < 2592000) {
    // 30 days
    final days = (seconds / 86400).round();
    return 'time_ago_days'.trParams({'count': '$days'});
  } else {
    final years = (seconds / 31536000).round();
    return 'time_ago_years'.trParams({'count': '$years'});
  }
}
