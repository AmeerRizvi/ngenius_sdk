class CardFormResults {
  const CardFormResults({
    required this.cardNumber,
    required this.cardExpiry,
    required this.cardSec,
    required this.name,
  });

  final String cardNumber;

  final String cardExpiry;

  final String cardSec;

  final String name;

  int get expYear => int.parse(cardExpiry.split('/')[1]) + 2000;

  int get expMonth => int.parse(cardExpiry.split('/')[0]);

  @override
  String toString() {
    return 'CardFormResults [ $cardNumber, $cardExpiry, $cardSec, $name,]';
  }
}
