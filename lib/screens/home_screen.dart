import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

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
              xs: 6,
              md: 6,
              lg: 6,
              child: const Center(child: Text("64 Cards"))),
          ResponsiveGridCol(
              xs: 6,
              md: 6,
              lg: 6,
              child: const Center(child: Text("12 Countries"))),
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
                  onPressed: () {},
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

  Widget cardItem() {
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Card Number: ************** 1244"),
                    Text("VISA")
                  ],
                )),
            ResponsiveGridCol(
                xs: 12, md: 12, lg: 12, child: const Text("CVV: ***")),
            ResponsiveGridCol(
                xs: 12,
                md: 12,
                lg: 12,
                child: const Text("Country: South Africa")),
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
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return cardItem();
              }),
        ],
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: const Text('Settings'),
          ),
          ListTile(
            title: const Text('Confgure Banned Countries'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // STATS
          stats(),
          // BUTTONS
          buttons(),
          // CARDS FROM TODAY LIST
          ResponsiveGridCol(child: cardList())
        ]),
      ),
    );
  }
}
