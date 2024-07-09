import 'package:flutter/material.dart';
import 'package:ngenius_sdk/src/utils/enums.dart';
import 'screens/checkout_screen.dart';

class NgeniusCheckout extends StatelessWidget {
  final String apiUrl;
  final String apiKey;
  final String outletId;
  final String currency;
  final int amount;
  final VoidCallback onPaymentCreated;
  final VoidCallback? onError;
  final LogLevel logLevel;

  const NgeniusCheckout({
    required this.apiUrl,
    required this.apiKey,
    required this.outletId,
    required this.currency,
    required this.amount,
    required this.onPaymentCreated,
    this.logLevel = LogLevel.all,
    this.onError,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckoutScreen(
      apiUrl: apiUrl,
      apiKey: apiKey,
      outletId: outletId,
      currency: currency,
      amount: amount,
      onPaymentCreated: onPaymentCreated,
      onError: onError,
      logLevel: logLevel,
    );
  }
}
