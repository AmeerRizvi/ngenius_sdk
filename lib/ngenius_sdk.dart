import 'package:flutter/material.dart';
import 'package:ngenius_sdk/src/screens/checkout_screen.dart';
import 'ngenius_sdk_platform_interface.dart';

class NgeniusSdk {
  Future<String?> getPlatformVersion() {
    return NgeniusSdkPlatform.instance.getPlatformVersion();
  }

  static void startCheckout({
    required BuildContext context,
    required String apiUrl,
    required String apiKey,
    required String outletId,
    required String currency,
    required int amount,
    required void Function() onPaymentCreated,
    void Function()? onError,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CheckoutScreen(
          apiUrl: apiUrl,
          apiKey: apiKey,
          outletId: outletId,
          currency: currency,
          amount: amount,
          onPaymentCreated: onPaymentCreated,
          onError: onError,
        ),
      ),
    );
  }
}
