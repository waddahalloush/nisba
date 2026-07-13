import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class WalletTransaction {
  final IconData icon;
  final String title;
  final String amount;
  final bool isCredit;

  const WalletTransaction({
    required this.icon,
    required this.title,
    required this.amount,
    required this.isCredit,
  });
}

class WalletController extends GetxController {
  final userName = 'محمد عبيد'.obs;
  final phoneNumber = '19615197479'.obs;
  final balance = 0.00.obs;
  final totalPayments = 135.00.obs;
  final totalTopUps = 200.00.obs;

  final transactions = <WalletTransaction>[
    const WalletTransaction(
      icon: Iconsax.wallet_add,
      title: 'شحن المحفظة',
      amount: '+ 50.00 QAR',
      isCredit: true,
    ),
    const WalletTransaction(
      icon: Iconsax.card_send,
      title: 'دفع',
      amount: '- 35.00 QAR',
      isCredit: false,
    ),
    const WalletTransaction(
      icon: Iconsax.gift,
      title: 'إهداء إلى أحمد محمد',
      amount: '+ 20.00 QAR',
      isCredit: true,
    ),
  ];

  void showBalance() {
    // TODO: Show balance details
  }

  void topUpWallet() {
    // TODO: Navigate to top-up screen
  }

  void sendGift() {
    // TODO: Navigate to gift credit screen
  }

  void payWithQR() {
    // TODO: Navigate to QR payment screen
  }
}
