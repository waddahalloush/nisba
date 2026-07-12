import 'dart:developer' as developer;

class AppLogger {
  static void logGreen(String msg) {
    developer.log('\x1B[32m$msg\x1B[0m');
  }

 static void logPink(String msg) {
    developer.log('\x1B[95m$msg\x1B[0m');
  }

 static void logPurple(String msg) {
    developer.log('\x1B[35m$msg\x1B[0m');
  }

 static void logBlue(String msg) {
    developer.log('\x1B[34m$msg\x1B[0m');
  }

 static void logWhite(String msg) {
    developer.log('\x1B[37m$msg\x1B[0m');
  }
}
