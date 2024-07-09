## 0.0.9

- Added test card support for 3DS and 3DS2 authentication.
- Fixed issue with Amex card support.
- Improved error message display for better troubleshooting.
- Introduced the following methods:
  - `fetchAccessToken`: Retrieves access token using provided API key and base URL.
  - `createPaymentOrder`: Creates a payment order with specified details.
  - `sendPaymentDetails`: Sends payment details for processing.
  - `authorizePayment`: Authorizes payment and checks the purchase state.
  - `sendDeviceMetadata`: Sends device metadata for 3DS2 authentication.
- Minor bug fixes and performance improvements.
