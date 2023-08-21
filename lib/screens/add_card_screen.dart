import 'package:cardly/classes/card_issuers.dart';
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

  const AddCardScreen({super.key, this.paramCardNumber, this.paramCardIssuer});

  final String? paramCardNumber;
  final String? paramCardIssuer;

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  String? errorMessage;
  final RegExp _visa = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
  final RegExp _master = RegExp(r'^5[1-5][0-9]{14}$');

  TextEditingController controller = TextEditingController();
  bool isLoading = true;
  String? cardType;

  @override
  void initState() {
    super.initState();
  }

  void initialzeStateAndBlocFromParamaters(CardBloc bloc) {
    if (isLoading) {
      if (widget.paramCardIssuer != null && widget.paramCardNumber != null) {
        setState(() {
          cardType = widget.paramCardIssuer;
          isLoading = false;
        });
        controller.text = widget.paramCardNumber!;
        bloc.changeNumber(widget.paramCardNumber!);
      } else {
        setState(() {
          cardType = CardIssuers.kdefault;
          isLoading = false;
        });
      }
    }
  }

  Widget numberField(CardBloc bloc) {
    return StreamBuilder(
      stream: bloc.number,
      builder: (context, snapshot) {
        return TextField(
          controller: controller,
          onChanged: (String? number) {
            if (number != null) {
              if (_visa.hasMatch(number)) {
                setState(() => cardType = CardIssuers.visa);
              } else if (_master.hasMatch(number)) {
                setState(() => cardType = CardIssuers.mastercard);
              } else {
                setState(() => cardType = CardIssuers.kdefault);
              }
              bloc.changeNumber(number);
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintStyle: TextStyle(color: Colors.grey[600]),
            hintText: '1234 4567 8910 1112',
            labelText: 'Card Number',
            prefixIcon: cardType == CardIssuers.kdefault
                ? const Icon(Icons.credit_card)
                : cardType == CardIssuers.visa
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

  Widget kpadding(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*------------^------------*
    * ------- CardBloc --------*
    * ------------+------------*/
    final CardBloc bloc = CardProvider.of(context);
    /*------------^------------*/

    if (isLoading) {
      initialzeStateAndBlocFromParamaters(bloc);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Add New Card"),
      ),
      body: SingleChildScrollView(
        child: ResponsiveGridRow(children: [
          ResponsiveGridCol(child: kpadding(numberField(bloc))),
          ResponsiveGridCol(child: kpadding(cvvField(bloc))),
          ResponsiveGridCol(child: kpadding(countryField(bloc))),
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
