import 'package:get/get.dart';

class PointLogEntry {
  final String title;
  final String date;
  final String points;
  final bool isEarned;

  const PointLogEntry({
    required this.title,
    required this.date,
    required this.points,
    required this.isEarned,
  });
}

class PointController extends GetxController {
  final totalPoints = 120.obs;
  final totalEarned = 320.obs;
  final totalRedeemed = 200.obs;
  final expiryDate = '31 ديسمبر 2025'.obs;

  final log = <PointLogEntry>[
    const PointLogEntry(
      title: 'شراء من مطعم البيت',
      date: '15 مايو 2025 10:30 ص',
      points: '+34 نقطة',
      isEarned: true,
    ),
    const PointLogEntry(
      title: 'استبدال إلى رصيد',
      date: '10 مايو 2025 04:15 م',
      points: '-50 نقطة',
      isEarned: false,
    ),
  ];

  void calculatePoints() {
    // TODO: Navigate to points calculator
  }

  void sendToFriend() {
    // TODO: Navigate to send points
  }

  void redeemToBalance() {
    // TODO: Navigate to redeem
  }
}
