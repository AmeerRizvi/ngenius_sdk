import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ngenius_sdk/src/models/card_form_results.dart';
import 'package:ngenius_sdk/src/utils/enums.dart';
import 'package:ngenius_sdk/src/utils/functions.dart';
import 'package:ngenius_sdk/src/utils/utils.dart';
import 'package:ngenius_sdk/src/widgets/card_form.dart';
import 'package:ngenius_sdk/src/widgets/error_screen.dart';
import 'package:ngenius_sdk/src/widgets/loading_screen.dart';
import 'package:ngenius_sdk/src/widgets/success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.apiUrl,
    required this.apiKey,
    required this.outletId,
    required this.currency,
    required this.amount,
    required this.onPaymentCreated,
    required this.logLevel,
    this.onError,
  });

  final void Function() onPaymentCreated;
  final void Function()? onError;
  final String apiUrl, apiKey, outletId, currency;
  final int amount;
  final LogLevel logLevel;

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isLoading = false;
  ScreenStatus screenStatus = ScreenStatus.details;
  ThreeDsState threeDsStatus = ThreeDsState.none;
  String? token, auth3dsUrl, authUrl, authBody;
  _showError() => showError(context, widget.onError);

  @override
  void initState() {
    super.initState();
    Logger.change(widget.logLevel);
  }

  @override
  Widget build(BuildContext context) {
    final apiUrl = widget.apiUrl;
    final apiKey = widget.apiKey;
    final outletId = widget.outletId;
    final currency = widget.currency;
    final amount = widget.amount;

    submit(CardFormResults p0) async {
      setState(() => isLoading = true);
      token = await fetchAccessToken(
        baseUrl: apiUrl,
        apiKey: apiKey,
        onError: () => _showError(),
      );

      final paymentUrl = await createPaymentOrder(
        baseUrl: apiUrl,
        token: token!,
        outletId: outletId,
        currency: currency,
        value: amount,
        onError: () => _showError(),
      );

      final paymentResponse = await sendPaymentDetails(
        results: p0,
        paymentUrl: paymentUrl!,
        token: token!,
        onError: () => _showError(),
      );

      final state = paymentResponse!.state;
      final threeDS = paymentResponse.threeDS;
      final threeDs2 = paymentResponse.threeDS2;

      if (state == "AWAIT_3DS") {
        if (threeDS != null) {
          threeDsStatus = ThreeDsState.threeDs;
          auth3dsUrl = paymentResponse.links.cnp3ds!.href;
          authUrl = threeDS.acsUrl;
          authBody =
              'PaReq=${threeDS.acsPaReq}&MD=${threeDS.acsMd}&TermUrl=${'https://google.com'}';

          setState(() {
            screenStatus = ScreenStatus.authentication;
          });
        } else if (threeDs2 != null) {
          threeDsStatus = ThreeDsState.threeDs2;
          auth3dsUrl = paymentResponse.links.cnp3ds2ChallengeResponse!.href;

          await sendDeviceMetadata(
            token: token!,
            authDeviceUrl: paymentResponse.links.cnp3ds2Authentication!.href,
            onError: () {
              setState(() => isLoading = false);
              _showError();
              return;
            },
            onSuccess: (acsUrl, base64Encoded) {
              authUrl = acsUrl;
              authBody = 'creq=$base64Encoded';

              setState(() {
                screenStatus = ScreenStatus.authentication;
              });
            },
          );
        }
      } else if (state == "AUTHORISED") {
        setState(() {
          isLoading = false;
          screenStatus = ScreenStatus.success;
        });
        widget.onPaymentCreated.call();
      } else {
        setState(() => isLoading = false);
        _showError();
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Builder(builder: (context) {
            if (screenStatus == ScreenStatus.details) {
              return cardView(amount, currency, submit);
            }

            if (screenStatus == ScreenStatus.authentication) {
              return authenticationWebview();
            }

            if (screenStatus == ScreenStatus.error) {
              return const ErrorScreen();
            }

            if (screenStatus == ScreenStatus.success) {
              return const SuccessScreen();
            }

            return const ErrorScreen();
          }),
          if (isLoading) const LoadingScreen()
        ],
      ),
    );
  }

  CardScreen cardView(int amount, String currency,
      Future<Null> Function(CardFormResults p0) submit) {
    return CardScreen(
      price: amount.toString(),
      currency: currency,
      onCardPay: (p0) async {
        try {
          await submit(p0);
        } catch (e) {
          setState(() {
            isLoading = false;
            screenStatus = ScreenStatus.error;
          });
          _showError();
        }
      },
    );
  }

  InAppWebView authenticationWebview() {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: Uri.parse('$authUrl'),
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: Uint8List.fromList(
          utf8.encode('$authBody'),
        ),
      ),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          javaScriptEnabled: true,
        ),
      ),
      onWebViewCreated: (controller) {
        controller.evaluateJavascript(source: '''
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        document.getElementsByTagName('head')[0].appendChild(meta);
      ''');
      },
      onLoadStart: (controller, url) {
        setState(() => isLoading = true);
        controller.evaluateJavascript(source: 'window.modifyViewport();');
      },
      onLoadStop: (controller, url) async {
        setState(() => isLoading = false);
        controller.evaluateJavascript(source: '''
        (function() {
          var meta = document.querySelector('meta[name=viewport]');
          if (!meta) {
            meta = document.createElement('meta');
            meta.name = 'viewport';
            document.getElementsByTagName('head')[0].appendChild(meta);
          }
          meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        })();
      ''');
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        setState(() => isLoading = true);

        var url = navigationAction.request.url.toString();

        if (url.startsWith("https://google.com")) {
          if (navigationAction.request.body != null) {
            final body = utf8.decode(navigationAction.request.body!);
            final params = Uri.splitQueryString(body);
            final data = threeDsStatus == ThreeDsState.threeDs
                ? {"PaRes": params['PaRes']}
                : threeDsStatus == ThreeDsState.threeDs2
                    ? {"base64EncodedCRes": params['cres']}
                    : null;
            if (data != null) {
              authorizePayment(
                url: auth3dsUrl!,
                token: token!,
                data: data,
                onSuccess: () {
                  setState(() {
                    isLoading = false;
                    screenStatus = ScreenStatus.success;
                  });
                  widget.onPaymentCreated.call();
                },
                onError: () {
                  setState(() {
                    isLoading = false;
                    screenStatus = ScreenStatus.details;
                    _showError();
                  });
                },
              );
            } else {
              setState(() {
                isLoading = false;
                screenStatus = ScreenStatus.details;
                _showError();
              });
            }

            return NavigationActionPolicy.CANCEL;
          }
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}
