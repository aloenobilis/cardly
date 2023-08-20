import 'package:flutter/material.dart';
import 'package:cardly/blocs/card_bloc.dart';
import 'package:cardly/utils/countries.dart';

Widget countryField(CardBloc bloc) {
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
        },
        value: initialCountryValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          filled: true,
          // ignore: prefer_null_aware_operators
          errorText: snapshot.error == null ? null : snapshot.error.toString(),
        ),
      );
    },
  );
}
