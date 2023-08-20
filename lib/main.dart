import 'package:cardly/resources/db_provider.dart';
import 'package:flutter/material.dart';

import 'package:cardly/screens/add_card_screen.dart';
import 'package:cardly/screens/home_screen.dart';
import 'package:cardly/blocs/card_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbProvider.init();
  runApp(const Cardly());
}

class Cardly extends StatelessWidget {
  const Cardly({super.key});

  @override
  Widget build(BuildContext context) {
    return CardProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.black54),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(),
        initialRoute: HomeScreen.id,
        routes: {
          HomeScreen.id: (context) => const HomeScreen(),
          AddCardScreen.id: (context) => const AddCardScreen(),
        },
      ),
    );
  }
}
