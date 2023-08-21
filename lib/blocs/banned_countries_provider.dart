import 'package:flutter/material.dart';
import 'banned_countries_bloc.dart';

class BannedCountriesProvider extends InheritedWidget {
  final bloc = BannedCountriesBloc();

  BannedCountriesProvider({Key? key, Widget? child})
      : super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;
  static BannedCountriesBloc of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<BannedCountriesProvider>())!
        .bloc;
  }
}
