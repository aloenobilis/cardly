import 'dart:convert';

class BannedCountries {
  int? id;
  List<dynamic>? countries;

  // default constructor
  BannedCountries({this.countries});

  // from database
  BannedCountries.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        countries = jsonDecode(parsedJson['countries']);

  // to database
  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "id": id,
      "countries": jsonEncode(countries),
    };
  }
}
