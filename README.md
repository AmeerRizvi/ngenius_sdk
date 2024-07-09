![Build](https://github.com/rrousselGit/freezed/workflows/Build/badge.svg)
[![pub package](https://img.shields.io/pub/v/ngenius_sdk.svg)](https://pub.dartlang.org/packages/ngenius_sdk)

A comprehensive solution for processing payments with Ngenius in your Flutter app.

# Motivation

Ngenius Flutter SDK simplifies the integration of Ngenius payment gateway in Flutter applications by providing seamless support for card payments, 3DS and 3DS2 authentication, and customizable UI components.

# Index

- [Motivation](#motivation)
- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Configuration](#configuration)
  - [Android](#android)
  - [iOS](#ios)
  - [Test Cards](#test-cards)
  - [Known Issues](#known-issues)
- [Additional Information](#additional-information)
- [License](#license)
- [Issues and Feedback](#issues-and-feedback)
- [Contributing](#contributing)

# Features

- Seamless integration with Ngenius payment gateway
- Support for card payments
- 3DS and 3DS2 authentication support
- Customizable UI components

https://github.com/AmeerRizvi/ngenius_sdk/assets/63542458/cef4abf3-eabb-4e81-be0f-1242f0aa6b02

# Getting Started

To use this plugin, add `ngenius_sdk` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  ngenius_sdk: ^0.0.8
```

# Usage

Import the package in your Dart code:

```dart
import 'package:ngenius_sdk/ngenius_sdk.dart';
```

To initiate a payment, use the `NgeniusCheckout` widget:

```dart
NgeniusCheckout(
  apiUrl: 'YOUR_API_URL',
  apiKey: 'YOUR_API_KEY',
  outletId: 'YOUR_OUTLET_ID',
  currency: 'CURRENCY',
  amount: 'AMOUNT', // Amount as an integer
  onPaymentCreated: () {
    // Handle successful payment creation
  },
  // Optional
  onError: () {
    // Handle payment errors
  },
)
```

# Configuration

Ensure you have the following permissions set up in your project:

## Android

Add the internet permission to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## iOS

No additional configuration required for iOS.

## Test Cards

- 4012001037141112: 3DS activated
- 4792445612017070: 3DS declined
- 5457210001000019: 3DS2 activated
- 4000000000000002: 3DS2 declined

## Known Issues

- Amex is not working
- Proper error message display needs to be built

# Additional Information

For more details on using the Ngenius SDK, please refer to the [official documentation](https://docs.ngenius-payments.com/reference).

# License

This project is licensed under the MIT License - see the [LICENSE](https://opensource.org/license/mit) file for details.

# Issues and Feedback

Please file issues, bugs, or feature requests in our [issue tracker](https://github.com/AmeerRizvi/ngenius_sdk/issues).

# Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

```

```
