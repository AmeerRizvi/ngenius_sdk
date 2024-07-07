import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              message,
              softWrap: false,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.fixed,
    ),
  );
}

enum ScreenStatus {
  details,
  authentication,
  success,
  error,
}

pprint(json) {
  var encoder = const JsonEncoder.withIndent("     ");
  String str = encoder.convert(json);
  log(str);
}

enum ThreeDsState {
  threeDs,
  threeDs2,
  none,
}

showError(BuildContext context, Function()? onError) {
  HapticFeedback.heavyImpact();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Center(child: Text('Payment failed')),
      content: const Text(
        'Something went wrong with your transaction. Please try again later.',
        textAlign: TextAlign.center,
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            onError?.call();
            Navigator.pop(ctx);
          },
          child: const Text(
            'Okay',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}
