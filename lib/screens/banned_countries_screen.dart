import 'package:cardly/classes/response.dart';
import 'package:cardly/models/bannedcountries.dart';
import 'package:cardly/utils/countries.dart';
import 'package:cardly/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'package:cardly/blocs/banned_countries_bloc.dart';
import 'package:cardly/blocs/banned_countries_provider.dart';

class BannedCountriesScreen extends StatefulWidget {
  static const String id = 'banned_countries_screen';
  const BannedCountriesScreen({super.key});

  @override
  State<BannedCountriesScreen> createState() => _BannedCountriesScreenState();
}

class _BannedCountriesScreenState extends State<BannedCountriesScreen> {
  bool isLoading = true;
  BannedCountries? bannedCountries;
  String? country;
  String? errorMessageAddBannedCountry;
  String? errorMessageGetBannedCountries;

  void setBannedCountriesToState(BannedCountriesBloc bloc) async {
    BlocResponse? response;
    if (isLoading) {
      response = await bloc.getBannedCountries();
    }

    if (response!.errorMessage != null) {
      setState(() {
        errorMessageGetBannedCountries = response!.errorMessage;
        isLoading = false;
      });
    } else {
      setState(() {
        bannedCountries = response!.payload;
        isLoading = false;
      });
    }
  }

  Widget kpadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: child,
    );
  }

  Widget bannedCountryField(BannedCountriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.country,
      builder: (context, snapshot) {
        return DropdownButtonFormField(
          items: countries.map((String country) {
            return DropdownMenuItem(
              value: country,
              child: Text(country),
            );
          }).toList(),
          onChanged: (newValue) {
            bloc.changeCountry(newValue!);
            setState(() {
              country = newValue;
            });
          },
          value: initialCountryValue,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            filled: true,
            errorText:
                // ignore: prefer_null_aware_operators
                snapshot.error == null ? null : snapshot.error.toString(),
            prefixIcon: const Icon(Icons.flag),
          ),
        );
      },
    );
  }

  Widget addBannedCountrySubmitButton(BannedCountriesBloc bloc) {
    return ElevatedButton(
        onPressed: () async {
          if (bannedCountries != null &&
              country != null &&
              country != initialCountryValue) {
            BlocResponse response =
                await bloc.addCountrySubmit(bannedCountries!);

            if (response.payload == true) {
              setState(() {
                errorMessageAddBannedCountry = null;
                isLoading = true;
              });
            } else {
              setState(
                  () => errorMessageAddBannedCountry = response.errorMessage);
            }
          }
        },
        child: const Text("Add Country"));
  }

  Widget bannedCountriesList() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          kpadding(
            const Text(
              "Banned Countries",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bannedCountries!.countries!.length,
            itemBuilder: (BuildContext conetxt, int index) {
              return kpadding(Text(
                "- ${bannedCountries!.countries![index]}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*------------^------------*
    * -- BannedCountriesBloc --*
    * ------------+------------*/
    final BannedCountriesBloc bloc = BannedCountriesProvider.of(context);
    /*------------^------------*/

    if (isLoading) {
      setBannedCountriesToState(bloc);
      return loader();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Banned Countries"),
      ),
      body: SingleChildScrollView(
        child: ResponsiveGridRow(children: [
          ResponsiveGridCol(child: kpadding(bannedCountryField(bloc))),
          ResponsiveGridCol(
              child: errorMessageAddBannedCountry == null
                  ? Container()
                  : Text(
                      errorMessageAddBannedCountry!,
                      style: const TextStyle(color: Colors.red),
                    )),
          ResponsiveGridCol(
              child: Center(
            child: addBannedCountrySubmitButton(bloc),
          )),
          ResponsiveGridCol(
              child: errorMessageGetBannedCountries == null
                  ? bannedCountriesList()
                  : Text(
                      errorMessageGetBannedCountries!,
                      style: const TextStyle(color: Colors.red),
                    )),
        ]),
      ),
    );
  }
}
