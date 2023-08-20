import 'package:flutter/material.dart';
import 'card_bloc.dart';

class CardProvider extends InheritedWidget {
  final bloc = CardBloc();

  CardProvider({Key? key, Widget? child}) : super(key: key, child: child!);

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => true;
  static CardBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CardProvider>())!.bloc;
  }
}
