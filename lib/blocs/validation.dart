import 'dart:async';

import 'package:cardly/utils/luhn.dart';
import 'package:cardly/utils/countries.dart' show initialCountryValue;

// REGEXES
RegExp _numeric = RegExp(r'^-?[0-9]+$');

mixin Validation {
  final validateNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (number, sink) {
    bool numberIsValid = Luhn().validate(number);

    if (numberIsValid) {
      sink.add(number);
    } else {
      sink.addError('Enter a valid card number');
    }
  });

  final validateCvv =
      StreamTransformer<String, String>.fromHandlers(handleData: (cvv, sink) {
    if (cvv.length >= 3 && cvv.length <= 4) {
      if (_numeric.hasMatch(cvv)) {
        sink.add(cvv);
      } else {
        sink.addError("Only numbers please");
      }
    } else {
      sink.addError("Enter a valid CVV");
    }
  });

  final validateCountry = StreamTransformer<String, String>.fromHandlers(
      handleData: (country, sink) {
    if (country != initialCountryValue) {
      sink.add(country);
    } else {
      sink.addError("Select a country");
    }
  });

  // country
  // ensure its not the default value
  // add an error to the error stream to show as error text widget
}
