import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ngenius_sdk/src/models/card_form_results.dart';
import 'package:ngenius_sdk/src/models/payment_response.dart';
import 'package:ngenius_sdk/src/utils/utils.dart';

Future<String?> fetchAccessToken({
  required String baseUrl,
  required String apiKey,
  required Function() onError,
}) async {
  try {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.options.headers['Authorization'] = 'Basic $apiKey';
    dio.options.headers['Content-Type'] = 'application/vnd.ni-identity.v1+json';

    final response = await dio.post(endpointAccessToken);

    final token = response.data['access_token'] as String;
    return token;
  } catch (e) {
    Logger.log("$e", 'fetchAccessToken');
    onError.call();
    return null;
  }
}

Future<String?> createPaymentOrder({
  required String baseUrl,
  required String token,
  required String outletId,
  required String currency,
  required int value,
  required Function() onError,
}) async {
  try {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/vnd.ni-payment.v2+json';
    dio.options.headers['Accept'] = 'application/vnd.ni-payment.v2+json';

    final response = await dio.post(
      endpointOrder(outletId),
      data: {
        "action": "PURCHASE",
        "amount": {"currencyCode": currency, "value": value}
      },
    );

    final paymentUrl = response.data["_embedded"]["payment"][0]["_links"]
        ["payment:card"]["href"] as String;

    return paymentUrl;
  } catch (e) {
    Logger.log("$e", 'createPaymentOrder');
    onError.call();
    return null;
  }
}

const endpointAccessToken = "/identity/auth/access-token";
String endpointOrder(String outletId) =>
    "/transactions/outlets/$outletId/orders";

Future<PaymentResponse?> sendPaymentDetails({
  required CardFormResults results,
  required String paymentUrl,
  required String token,
  required Function() onError,
}) async {
  try {
    final dio = Dio(BaseOptions(baseUrl: paymentUrl));
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/vnd.ni-payment.v2+json';
    dio.options.headers['Accept'] = 'application/vnd.ni-payment.v2+json';

    final response = await dio.put('', data: {
      "pan": results.cardNumber,
      "expiry": "${results.expYear}-${results.expMonth}",
      "cvv": results.cardSec,
      "cardholderName": results.name
    });

    return PaymentResponse.fromJson(response.data);
  } catch (e) {
    Logger.log("$e", 'sendPaymentDetails');
    onError.call();
    return null;
  }
}

Future<void> authorizePayment({
  required String url,
  required String token,
  required Map data,
  required Function() onSuccess,
  required Function() onError,
}) async {
  try {
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/vnd.ni-payment.v2+json';
    dio.options.headers['Accept'] = 'application/vnd.ni-payment.v2+json';

    final response = await dio.post(url, data: data);
    final state = response.data["state"];
    log(state);
    if (state == 'PURCHASED') {
      onSuccess.call();
    } else {
      onError.call();
    }
  } catch (e) {
    Logger.log("$e", 'authorizePayment');
    log("$e");
    onError.call();
  }
}

Future<void> sendDeviceMetadata({
  required String? authDeviceUrl,
  required String token,
  required Function() onError,
  required Function(String, String) onSuccess,
}) async {
  try {
    final data = {
      "deviceChannel": "BRW",
      "threeDSCompInd": "Y",
      "notificationURL": "https://google.com",
      "browserInfo": {
        "browserAcceptHeader": "application/json",
        "browserJavaEnabled": true,
        "browserLanguage": "en",
        "browserTZ": "0",
        "browserUserAgent":
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.93 Safari/537.36",
        "browserColorDepth": "30",
        "browserScreenHeight": "1055",
        "browserScreenWidth": "1680",
        "browserJavascriptEnabled": true,
        "browserIP": "192.168.1.1",
        "challengeWindowSize": "05"
      }
    };
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/vnd.ni-payment.v2+json';
    dio.options.headers['Accept'] = 'application/vnd.ni-payment.v2+json';

    if (authDeviceUrl == null) {
      log("authDeviceUrl is null");
      onError.call();
      return;
    }
    final response = await dio.post(authDeviceUrl, data: data);

    if (response.data['state'] == 'AWAIT_3DS') {
      final acsUrl = response.data['3ds2']['acsURL'];
      final base64Encoded = response.data['3ds2']['base64EncodedCReq'];
      onSuccess(acsUrl, base64Encoded);
    }
  } catch (e) {
    Logger.log("$e", 'sendDeviceMetadata');
    onError.call();
  }
}
