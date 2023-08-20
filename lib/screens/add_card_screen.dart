import 'package:cardly/classes/response.dart';
import 'package:cardly/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import 'package:cardly/blocs/card_bloc.dart';
import 'package:cardly/blocs/card_provider.dart';
import 'package:cardly/widgets/cvv_field.dart';
import 'package:cardly/widgets/country_field.dart';

class AddCardScreen extends StatefulWidget {
  static const String id = 'add_card_screen';
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  String? errorMessage;
  final RegExp _visa = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
  final RegExp _master = RegExp(r'^5[1-5][0-9]{14}$');

  String? cardType;
  final String kVisa = 'VISA';
  final String kMasterCard = 'MASTERCARD';
  final String kDefault = 'DEFAULT';

  @override
  void initState() {
    super.initState();
    cardType = kDefault;
  }

  Widget numberField(CardBloc bloc) {
    return StreamBuilder(
      stream: bloc.number,
      builder: (context, snapshot) {
        return TextField(
          onChanged: (String? number) {
            if (number != null) {
              if (_visa.hasMatch(number)) {
                setState(() => cardType = kVisa);
              } else if (_master.hasMatch(number)) {
                setState(() => cardType = kMasterCard);
              } else {
                setState(() => cardType = kDefault);
              }

              bloc.changeNumber(number);
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.grey[600]),
            hintText: '1234 4567 8910 1112',
            labelText: 'Card Number',
            prefixIcon: cardType == 'DEFAULT'
                ? const Icon(Icons.credit_card)
                : cardType == 'VISA'
                    ? Image.asset(
                        'assets/visa.png',
                        scale: 5,
                      )
                    : Image.asset(
                        'assets/mastercard.png',
                        scale: 5,
                      ),
            // ignore: prefer_null_aware_operators
            errorText:
                // ignore: prefer_null_aware_operators
                snapshot.error == null ? null : snapshot.error.toString(),
          ),
        );
      },
    );
  }

  Widget submitAddCardButton(CardBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return ElevatedButton(
            onPressed: () async {
              if (!snapshot.hasError && snapshot.hasData) {
                bloc.changeError(false);
                BlocResponse response = await bloc.addCardSubmit(cardType);
                if (response.payload == true && response.errorMessage == null) {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                } else {
                  setState(() {
                    errorMessage = response.errorMessage;
                  });
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
    * ------- CardBloc --------*
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
              child: errorMessage == null
                  ? const Text('')
                  : Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )),
          ResponsiveGridCol(
              child: Center(
            child: submitAddCardButton(bloc),
          )),
        ]),
      ),
    );
  }
}
