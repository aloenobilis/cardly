import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:intl/intl.dart';

import 'package:cardly/blocs/card_bloc.dart';
import 'package:cardly/blocs/card_provider.dart';
import 'package:cardly/classes/response.dart';
import 'package:cardly/models/bankcard.dart';
import 'package:cardly/screens/add_card_screen.dart';
import 'package:cardly/screens/banned_countries_screen.dart';
import 'package:cardly/widgets/loader.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  +++++++++++++++++++++++++ STATE ++++++++++++++++++++++++++++
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  List<BankCard> cards = [];
  String? statNumberCountries = '0';
  String? statNumberCards = '0';
  String? errorMessageGetCards;

  void setCardsToState(CardBloc bloc) async {
    BlocResponse? response;

    if (isLoading) {
      response = await bloc.getCards();
    }

    if (response != null) {
      if (response.payload != null) {
        List<String> countries = [];
        for (var item in response.payload) {
          countries.add(item.country);
        }

        setState(() {
          statNumberCards = response!.payload.length.toString();
          statNumberCountries = countries.toSet().toList().length.toString();
          cards = response.payload;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessageGetCards = response!.errorMessage;
          isLoading = false;
        });
      }
    }
  }

  /*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  +++++++++++++++++++++++++ WIDGETS ++++++++++++++++++++++++++
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

  /// Show total number of uniqe cards and countries
  ResponsiveGridCol stats() {
    return ResponsiveGridCol(
        xs: 12,
        md: 12,
        lg: 12,
        child: ResponsiveGridRow(children: [
          ResponsiveGridCol(
              child: const Center(child: Text("Session Statistics: "))),
          ResponsiveGridCol(
              xs: 6,
              md: 6,
              lg: 6,
              child: Center(child: Text("$statNumberCards Cards"))),
          ResponsiveGridCol(
              xs: 6,
              md: 6,
              lg: 6,
              child: Center(child: Text("$statNumberCountries Countries"))),
        ]));
  }

  /// Allow the ability to add a card by using a form input, or to populate
  /// the form by capturing the card details using the camera.
  ResponsiveGridCol buttons() {
    return ResponsiveGridCol(
        xs: 12,
        md: 12,
        lg: 12,
        child: ResponsiveGridRow(children: [
          ResponsiveGridCol(
              xs: 6,
              md: 6,
              lg: 6,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddCardScreen()));
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 24.0,
                  ),
                  label: const Text('Add Card'),
                ),
              )),
          ResponsiveGridCol(
              xs: 6,
              md: 6,
              lg: 6,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_a_photo_outlined,
                    size: 24.0,
                  ),
                  label: const Text('Capture Card'),
                ),
              )),
        ]));
  }

  Widget cardItem(BankCard card) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(4),
          child: ResponsiveGridRow(children: [
            ResponsiveGridCol(
                xs: 12,
                md: 12,
                lg: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Card Number: ${card.number}"),
                    card.cardType == 'DEFAULT'
                        ? const Text('...')
                        : card.cardType == 'VISA'
                            ? Image.asset(
                                'assets/visa.png',
                                scale: 5,
                              )
                            : Image.asset(
                                'assets/mastercard.png',
                                scale: 5,
                              )
                  ],
                )),
            ResponsiveGridCol(
                xs: 12, md: 12, lg: 12, child: Text("CVV: ${card.cvv}")),
            ResponsiveGridCol(
                xs: 12,
                md: 12,
                lg: 12,
                child: Text("Country: ${card.country}")),
            ResponsiveGridCol(
                xs: 12,
                md: 12,
                lg: 12,
                child: Text(
                    "Added: ${DateFormat('dd/MM/yyyy, HH:mm').format(card.created!)}"))
          ]),
        ),
      ),
    );
  }

  Widget cardList() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Cards from this session: "),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                return cardItem(cards[index]);
              }),
        ],
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: const Text('Settings'),
          ),
          ListTile(
            title: const Text('Configure Banned Countries'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BannedCountriesScreen()));
            },
          ),
        ],
      ),
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
      setCardsToState(bloc);
      return loader();
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: drawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Cardly"),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveGridRow(children: [
          // BUTTONS
          buttons(),
          // STATS
          stats(),
          // CARDS FROM TODAY LIST
          errorMessageGetCards == null
              ? ResponsiveGridCol(
                  child: cards.isEmpty ? const Text("No cards") : cardList())
              : ResponsiveGridCol(
                  child: Text(
                  errorMessageGetCards!,
                  style: const TextStyle(color: Colors.red),
                )),
        ]),
      ),
    );
  }
}
