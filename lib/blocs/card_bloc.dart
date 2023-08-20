import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:cardly/blocs/validation.dart';

class CardBloc with Validation {
  // streams
  final _number = BehaviorSubject<String>();
  final _cvv = BehaviorSubject<String>();
  final _country = BehaviorSubject<String>();
  final _err = BehaviorSubject<bool>();

  // Add data to stream
  Function(String) get changeNumber => _number.sink.add;
  Function(String) get changeCvv => _cvv.sink.add;
  Function(String) get changeCountry => _country.sink.add;
  Function(bool) get changeError => _err.sink.add;

  // Retreive data from stream=m
  Stream<String> get number => _number.stream.transform(validateNumber);
  Stream<String> get cvv => _cvv.stream.transform(validateCvv);
  Stream<String> get country => _country.stream.transform(validateCountry);
  Stream<bool> get err => _err.stream;

  Stream<bool> get submitValid => Rx.combineLatest3(
      number, cvv, country, (String a, String b, String c) => true);

  // methods
  Future<bool> addCardSubmit() async {
    bool cardSuccessfullyAdded = false;

    final validNumber = _number.value;
    final validCvv = _cvv.value;
    // TODO: ensure country is not in banned countries
    final validCountry = _country.value;

    print("*" * 15);
    print("NUMBER: $validNumber");
    print("CVV: $validCvv");
    print("COUNTRY: $validCountry");

    return cardSuccessfullyAdded;
  }

  // dispose
  void dispose() {
    _number.close();
    _cvv.close();
    _country.close();
    _err.close();
  }
}
