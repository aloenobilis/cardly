import 'dart:async';
import 'package:cardly/classes/response.dart';
import 'package:cardly/models/bannedcountries.dart';
import 'package:cardly/resources/db_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:cardly/blocs/validation.dart';

class BannedCountriesBloc with Validation {
  // streams
  final _country = BehaviorSubject<String>();

  // Add data to stream
  Function(String) get changeCountry => _country.sink.add;

  // Retreive data from stream
  Stream<String> get country => _country.stream.transform(validateCountry);

  // methods

  // take the existing banned countries, append the new country to it
  Future<BlocResponse> addCountrySubmit(BannedCountries bannedcountries) async {
    final validCountry = _country.value;

    if (bannedcountries.countries!.contains(validCountry)) {
      return BlocResponse(
          payload: null, errorMessage: "Country is already banned.");
    }

    bannedcountries.countries!.add(validCountry);
    DbProviderResponse response =
        await dbProvider.addBannedCountry(bannedcountries);

    return BlocResponse.fromDbProviderResponse(response);
  }

  Future<BlocResponse> getBannedCountries() async {
    DbProviderResponse response = await dbProvider.getBannedCountry();
    return BlocResponse.fromDbProviderResponse(response);
  }

  // dispose
  void dispose() {
    _country.close();
  }
}
