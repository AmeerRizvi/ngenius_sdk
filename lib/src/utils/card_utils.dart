import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngenius_sdk/ngenius_sdk.dart';

class CardPayButton extends StatefulWidget {
  const CardPayButton({
    super.key,
    required this.onPressed,
    this.initStatus,
    required this.text,
  });
  final CardPayButtonStatus? initStatus;
  final Function() onPressed;
  final String text;

  @override
  CardPayButtonState createState() => CardPayButtonState();
}

class CardPayButtonState extends State<CardPayButton> {
  CardPayButtonStatus status = CardPayButtonStatus.not_ready;

  updateStatus(CardPayButtonStatus newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initStatus != null) {
      status = widget.initStatus!;
    }
  }

  bool get shouldBeGreen => !shouldBeBlue && !shouldBeRed;
  bool get shouldBeBlue => status == CardPayButtonStatus.not_ready;
  bool get shouldBeRed => status == CardPayButtonStatus.fail;

  Color get color => Colors.black;

  Widget get displayedWidget {
    Widget w = Text(widget.text,
        style: TextStyle(color: Colors.grey.shade200, fontSize: 20.0));

    switch (status) {
      case CardPayButtonStatus.ready:
        break;
      case CardPayButtonStatus.processing:
        w = SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: Colors.green.shade50,
            strokeWidth: 2.0,
          ),
        );
        break;
      case CardPayButtonStatus.success:
        w = Icon(
          Icons.check_circle,
          color: Colors.green.shade100,
        );
        break;
      case CardPayButtonStatus.fail:
        w = Icon(
          Icons.highlight_remove_rounded,
          color: Colors.red.shade900,
        );
        break;
      default:
        break;
    }
    return w;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: (status == CardPayButtonStatus.ready)
          ? () => widget.onPressed()
          : () => {},
      child: displayedWidget,
    );
  }
}

class FormValidator {
  String? validateEmail(String input) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);

    if (input.isEmpty) {
      return 'Entry Required';
    } else if (!regExp.hasMatch(input)) {
      return 'Invalid Email';
    } else {
      return null;
    }
  }

  String? validateName(String input) {
    const pattern = r'(^[a-zA-Z]{1,35}$)';
    final regExp = RegExp(pattern);

    if (input.isEmpty) {
      return 'Entry Required';
    } else if (input.length > 35) {
      return 'Maximum of 35 characters';
    } else if (!regExp.hasMatch(input)) {
      return 'Only alpha characters accepted';
    } else {
      return null;
    }
  }

  String? validatePhone(String input) {
    const pattern = r'(^[0-9]{10}$)';
    final regExp = RegExp(pattern);
    const pattern2 = r'(^\d{3}-\d{3}-\d{4}$)';
    final regExp2 = RegExp(pattern2);

    if (input.isEmpty) {
      return 'Entry Required';
    } else if (input.length > 10) {
      return 'Maximum of 10 digits';
    } else if (!(regExp.hasMatch(input) || regExp2.hasMatch(input))) {
      return 'Only numeric digits accepted';
    } else {
      return null;
    }
  }

  static String getDisplayAmexNumberFormat(String input) {
    input = input.replaceAll(RegExp("[^\\d]"), "");
    if (input.length >= 4) {
      input = '${input.substring(0, 4)} ${input.substring(4)}';
    }
    if (input.length >= 11) {
      input = '${input.substring(0, 9)} ${input.substring(9)}';
    }
    if (input.length >= 18) {
      input = input.substring(0, 18);
    }
    return input;
  }

  static String getDisplayCreditNumberFormat(String input) {
    input = input.replaceAll(RegExp("[^\\d]"), "");
    if (input.length >= 4) {
      input = '${input.substring(0, 4)} ${input.substring(4)}';
    }
    if (input.length >= 9) {
      input = '${input.substring(0, 9)} ${input.substring(9)}';
    }
    if (input.length >= 14) {
      input = '${input.substring(0, 14)} ${input.substring(14)}';
    }
    if (input.length >= 19) {
      input = input.substring(0, 19);
    }
    return input;
  }

  static String getDisplayCreditExpFormat(String input) {
    input = input.replaceAll(RegExp("[^\\d]"), "");

    if (input.isNotEmpty &&
        (input.length == 1) &&
        (input[0] != '0' && input[0] != '1')) {
      input = '0$input';
    }
    if (input.length >= 2) {
      input = '${input.substring(0, 2)}/${input.substring(2)}';
    }
    if (input.length >= 5) {
      input = input.substring(0, 5);
    }
    return input;
  }
}

abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator({this.regexSource});
  final String? regexSource;

  @override
  bool isValid(String value) {
    try {
      final regex = RegExp(regexSource!);
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({this.editingValidator});
  final StringValidator? editingValidator;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = editingValidator!.isValid(oldValue.text);
    final newValueValid = editingValidator!.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class EmailEditingRegexValidator extends RegexValidator {
  EmailEditingRegexValidator()
      : super(
            regexSource:
                "^[a-zA-Z0-9_.+-]*(@([a-zA-Z0-9-]*(\\.[a-zA-Z0-9-]*)?)?)?\$");
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator()
      : super(
            regexSource: "(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-]+\$)");
}

class PhoneSubmitRegexValidator extends RegexValidator {
  PhoneSubmitRegexValidator()
      : super(
            regexSource:
                r'(^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$)');
}

class CreditNumberSubmitRegexValidator extends RegexValidator {
  CreditNumberSubmitRegexValidator()
      : super(regexSource: r'^\d{4}(?:\s?\d{4}){3}$');
}

class CreditExpirySubmitRegexValidator extends RegexValidator {
  CreditExpirySubmitRegexValidator()
      : super(regexSource: r'^(0[1-9]|1[0-2])\/?[0-2][0-9]|3[0-1]$');
}

class CreditCvvSubmitRegexValidator extends RegexValidator {
  CreditCvvSubmitRegexValidator() : super(regexSource: r'^[0-9]{3,4}$');
}

class CreditNameSubmitRegexValidator extends RegexValidator {
  CreditNameSubmitRegexValidator() : super(regexSource: r'^[a-zA-Z\s]*$');
}

class AddressLineSubmitRegexValidator extends RegexValidator {
  AddressLineSubmitRegexValidator() : super(regexSource: r'^[a-zA-Z0-9\s]*$');
}

class AddressCitySubmitRegexValidator extends RegexValidator {
  AddressCitySubmitRegexValidator() : super(regexSource: r'^[a-zA-Z\s]*$');
}

class AddressPostalSubmitRegexValidator extends RegexValidator {
  AddressPostalSubmitRegexValidator() : super(regexSource: r'^[0-9]{5}$');
}

class AddressStateSubmitRegexValidator extends RegexValidator {
  AddressStateSubmitRegexValidator() : super(regexSource: r'^[A-Z]{2}$');
}

class PhoneRegexValidator extends RegexValidator {
  PhoneRegexValidator() : super(regexSource: r'^[0-9]{10}$');
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

bool amexCheck(String? value) =>
    (value?.replaceAll(' ', '').trim().length == 15);
