import 'package:test/test.dart';
import 'package:rxdart/rxdart.dart';

import 'package:cardly/blocs/card_bloc.dart';

void main() {
  late CardBloc bloc;
  setUp(() {
    bloc = CardBloc();
  });

  group('Validation', () {
    test('Validate Number', () {
      var validNumber = '4242424242424242';
      bloc.changeNumber(validNumber);
      bloc.number.listen(
        (event) {
          expect(event, validNumber);
        },
      );
    });

    test('Validate CVV', () {
      var validCVV = '123';
      bloc.changeCvv(validCVV);
      bloc.cvv.listen(
        (event) {
          expect(event, validCVV);
        },
      );
    });

    test('Validate Country', () {
      var validCountry = 'South Africa';
      bloc.changeCountry(validCountry);
      bloc.country.listen(
        (event) {
          expect(event, validCountry);
        },
      );
    });
  });
}
