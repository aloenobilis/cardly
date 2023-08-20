import 'package:cardly/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'package:cardly/blocs/card_bloc.dart';
import 'package:cardly/blocs/card_provider.dart';
import 'package:cardly/widgets/number_field.dart';
import 'package:cardly/widgets/cvv_field.dart';
import 'package:cardly/widgets/country_field.dart';

class AddCardScreen extends StatefulWidget {
  static const String id = 'add_card_screen';
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  Widget submitAddCardButton(CardBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return ElevatedButton(
            onPressed: () async {
              if (!snapshot.hasError && snapshot.hasData) {
                bloc.changeError(false);
                bool cardSuccessfullyAdded = await bloc.addCardSubmit();
                if (cardSuccessfullyAdded) {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                }
              }
            },
            child: const Text("Add Card"));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*------------^------------*
    * ------- AuthBloc --------*
    * ------------+------------*/
    final CardBloc bloc = CardProvider.of(context);
    /*------------^------------*/

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Add New Card"),
      ),
      body: SingleChildScrollView(
        child: ResponsiveGridRow(children: [
          ResponsiveGridCol(child: numberField(bloc)),
          ResponsiveGridCol(child: cvvField(bloc)),
          ResponsiveGridCol(child: countryField(bloc)),
          ResponsiveGridCol(
              child: Center(
            child: submitAddCardButton(bloc),
          )),
        ]),
      ),
    );
  }
}
