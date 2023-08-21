import 'dart:convert';

import 'package:test/test.dart';
import 'package:cardly/models/bannedcountries.dart';

void main() {
  late Map<String, dynamic> fixture;
  setUp(() {
    fixture = {
      "id": 1,
      "countries": jsonEncode(['South Africa']),
    };
  });

  test('BannedCountries is created from db', () {
    BannedCountries bc = BannedCountries.fromDb(fixture);
    expect(bc.runtimeType, BannedCountries);
  });

  test('BannedCountries converts to database representation', () {
    BannedCountries bc = BannedCountries.fromDb(fixture);
    Map<String, dynamic> bcdb = bc.toMapForDb();
    expect(bcdb['countries'], fixture['countries']);
  });
}
