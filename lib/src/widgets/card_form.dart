import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ngenius_sdk/src/models/card_form_results.dart';
import 'package:ngenius_sdk/src/utils/card_utils.dart';
import 'package:text_form_field_wrapper/text_form_field_wrapper.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({
    super.key,
    this.initBuyerName = '',
    this.onCardPay,
    this.payBtnKey,
    this.formKey,
    this.displayTestData = true,
    this.submitLabel = 'Pay',
    this.currency,
    this.price,
  });

  final String initBuyerName;

  final Function(CardFormResults)? onCardPay;

  final GlobalKey<CardPayButtonState>? payBtnKey;

  final GlobalKey<FormState>? formKey;

  final String submitLabel;

  final bool displayTestData;

  final String? currency;

  final String? price;

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late final GlobalKey<FormState> _formKey;

  late final GlobalKey<CardPayButtonState>? payBtnKey;

  CardBrand brand = CardBrand.n_a;

  bool get isCvvFront => brand == CardBrand.amex;

  int chosenCountryIndex = 0;

  TextEditingController cCardNumber = TextEditingController();
  TextEditingController cExpiry = TextEditingController();
  TextEditingController cSecurity = TextEditingController();
  TextEditingController cName = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.formKey != null) {
      _formKey = widget.formKey!;
    } else {
      _formKey = GlobalKey<FormState>();
    }

    payBtnKey = widget.payBtnKey;

    if (widget.displayTestData) {
      cName.text = 'John Doe';
      cCardNumber.text = '4012001037141112';
      cExpiry.text = '12/24';
      cSecurity.text = '424';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initBuyerName.isNotEmpty) {
      cName.text = widget.initBuyerName;
    }

    final submitLabel = widget.submitLabel +
        (widget.currency == null ? "" : " ${widget.currency}") +
        (widget.price == null ? "" : " ${widget.price}");

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(4, 16, 0, 4),
                  child: Text('Card Information'),
                ),
              ],
            ),
            TextFormFieldWrapper(
              borderFocusedThickness: 2,
              borderThickness: 2,
              position: TextFormFieldPosition.top,
              formField: TextFormField(
                controller: cCardNumber,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (CreditNumberSubmitRegexValidator().isValid(value!)) {
                    return null;
                  }
                  return 'Enter a valid card number';
                },
                inputFormatters: [
                  MaskedTextInputFormatter(
                    mask: brand == CardBrand.amex
                        ? 'xxxx xxxxxxx xxxx'
                        : 'xxxx xxxx xxxx xxxx',
                    separator: ' ',
                  )
                ],
                decoration: const InputDecoration(
                  hintText: '1234 1234 1234 1232',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  border: InputBorder.none,
                ),
                onChanged: (input) {
                  CardBrand newBrand =
                      CardTypeRegs.findBrand(input.replaceAll(' ', ''));
                  if (brand != newBrand) {
                    setState(() {
                      brand = newBrand;
                    });
                  }
                },
              ),
              suffix: _BrandsDisplay(
                brand: brand,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormFieldWrapper(
                    borderFocusedThickness: 2,
                    borderThickness: 2,
                    position: TextFormFieldPosition.bottomLeft,
                    formField: TextFormField(
                      controller: cExpiry,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (CreditExpirySubmitRegexValidator()
                            .isValid(value!)) {
                          return null;
                        }
                        return "Invalid";
                      },
                      inputFormatters: [
                        MaskedTextInputFormatter(
                          mask: 'xx/xx',
                          separator: '/',
                        )
                      ],
                      decoration: const InputDecoration(
                        hintText: 'MM / YY',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormFieldWrapper(
                    borderFocusedThickness: 2,
                    borderThickness: 2,
                    position: TextFormFieldPosition.bottomRight,
                    formField: TextFormField(
                      controller: cSecurity,
                      validator: (value) {
                        if (CreditCvvSubmitRegexValidator().isValid(value!)) {
                          return null;
                        }
                        return "Invalid";
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskedTextInputFormatter(
                          mask: brand == CardBrand.amex ? 'xxxx' : 'xxx',
                          separator: '',
                        )
                      ],
                      decoration: const InputDecoration(
                        hintText: 'CVC',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                    suffix: SizedBox(
                      height: 30,
                      width: 30,
                      child: isCvvFront
                          ? Image.asset('assets/images/cvv_front.png',
                              package: 'checkout_screen_ui')
                          : Image.asset('assets/images/cvv_back.png',
                              package: 'checkout_screen_ui'),
                    ),
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(4, 16, 0, 4),
                  child: Text('Name on card'),
                ),
              ],
            ),
            TextFormFieldWrapper(
              borderFocusedThickness: 2,
              borderThickness: 2,
              formField: TextFormField(
                controller: cName,
                keyboardType: TextInputType.name,
                validator: (input) {
                  if (input!.isNotEmpty &&
                      CreditNameSubmitRegexValidator().isValid(input)) {
                    return null;
                  } else {
                    return 'Enter a valid name';
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 16,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CardPayButton(
              key: payBtnKey,
              initStatus: CardPayButtonStatus.ready,
              text: submitLabel,
              onPressed: () {
                bool result = _formKey.currentState!.validate();
                if (result) {
                  _formKey.currentState!.save();
                  if (widget.onCardPay == null) {
                    return;
                  }
                  widget.onCardPay!(
                    CardFormResults(
                      cardNumber: cCardNumber.text.replaceAll(' ', ''),
                      cardExpiry: cExpiry.text,
                      cardSec: cSecurity.text,
                      name: cName.text,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum CardBrand { n_a, visa, masterCard, discover, amex, diners, jcb, union }

class CardTypeRegs {
  static final RegExp _visa = RegExp(r'^4[0-9]{0,}$');
  static final RegExp _master =
      RegExp(r'^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]{0,}$');
  static final RegExp _discover = RegExp(
      r'^(6011|65|64[4-9]|62212[6-9]|6221[3-9]|622[2-8]|6229[01]|62292[0-5])[0-9]{0,}$');
  static final RegExp _amex = RegExp(r'^3[47][0-9]{0,}$');
  static final RegExp _diners = RegExp(r'^3(?:0[0-59]{1}|[689])[0-9]{0,}$');
  static final RegExp _jcb = RegExp(r'^(?:2131|1800|35)[0-9]{0,}$');
  static final RegExp _union = RegExp(r'^(62|88)\d+$');

  static CardBrand findBrand(String cardNUmber) {
    if (_visa.matchAsPrefix(cardNUmber) != null) return CardBrand.visa;
    if (_master.matchAsPrefix(cardNUmber) != null) return CardBrand.masterCard;
    if (_discover.matchAsPrefix(cardNUmber) != null) return CardBrand.discover;
    if (_diners.matchAsPrefix(cardNUmber) != null) return CardBrand.diners;
    if (_amex.matchAsPrefix(cardNUmber) != null) return CardBrand.amex;
    if (_jcb.matchAsPrefix(cardNUmber) != null) return CardBrand.jcb;
    if (_union.matchAsPrefix(cardNUmber) != null) return CardBrand.union;
    return CardBrand.n_a;
  }
}

class _BrandsDisplay extends StatefulWidget {
  const _BrandsDisplay({this.brand = CardBrand.n_a});
  final CardBrand brand;

  @override
  _BrandsDisplayState createState() => _BrandsDisplayState();
}

class _BrandsDisplayState extends State<_BrandsDisplay> {
  bool get displayAll => (widget.brand == CardBrand.n_a);
  int counter = 0;
  bool isVisible = true;

  Widget diners = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset('assets/images/card_diners.png',
        package: 'checkout_screen_ui'),
  );
  Widget jcb = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset('assets/images/card_jcb.png',
        package: 'checkout_screen_ui'),
  );
  Widget union = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset('assets/images/card_union_pay.png',
        package: 'checkout_screen_ui'),
  );
  Widget discover = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset('assets/images/card_discover.png',
        package: 'checkout_screen_ui'),
  );
  Widget visa = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset('assets/images/card_visa.png',
        package: 'checkout_screen_ui'),
  );
  Widget master = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset('assets/images/card_mastercard.png',
        package: 'checkout_screen_ui'),
  );
  Widget amex = SizedBox(
    height: 15,
    width: 30,
    child: Image.asset('assets/images/card_amex.png',
        package: 'checkout_screen_ui'),
  );

  Widget? image;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 3);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (timer.tick % 4 == 0) {
        setState(() {
          image = discover;
        });
      } else if (timer.tick % 4 == 1) {
        setState(() {
          image = jcb;
        });
      } else if (timer.tick % 4 == 2) {
        setState(() {
          image = diners;
        });
      } else if (timer.tick % 4 == 3) {
        setState(() {
          image = union;
        });
      }
    });
  }

  Widget get mainImage {
    switch (widget.brand) {
      case CardBrand.amex:
        return amex;
      case CardBrand.masterCard:
        return master;
      case CardBrand.discover:
        return discover;
      case CardBrand.diners:
        return diners;
      case CardBrand.jcb:
        return jcb;
      case CardBrand.union:
        return union;
      default:
        return visa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.brand != CardBrand.n_a)
        ? mainImage
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              visa,
              master,
              amex,
              Container(
                constraints: const BoxConstraints(maxWidth: 30, maxHeight: 15),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 700),
                  child: image ?? discover,
                ),
              ),
            ],
          );
  }
}
