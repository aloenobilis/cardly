import 'package:test/test.dart';
import 'package:cardly/models/bankcard.dart';

void main() {
  late Map<String, dynamic> fixture;
  setUp(() {
    fixture = {
      "id": 1,
      "number": "12345678910112",
      "cvv": "123",
      "cardType": "visa",
      "country": "South Africa",
      "created": "2023-08-21 15:17:30.330"
    };
  });

  test('BankCard is created from db', () {
    BankCard card = BankCard.fromDb(fixture);
    expect(card.runtimeType, BankCard);
  });

  test('BankCard converts to database representation', () {
    BankCard card = BankCard.fromDb(fixture);
    Map<String, dynamic> cardDb = card.toMapForDb();
    expect(cardDb['number'], fixture['number']);
  });
}
