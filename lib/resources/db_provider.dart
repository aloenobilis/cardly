import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:cardly/models/bankcard.dart';
import 'package:cardly/classes/response.dart';

class DbProvider {
  Database? db;

  Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = p.join(documentsDirectory.path, "cardly.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute('''
        CREATE TABLE BankCard
        (
          id INTEGER PRIMARY KEY,
          number TEXT,
          cvv TEXT,
          cardType TEXT,
          country TEXT,
          created TEXT
        )
        ''');
    });
  }

  /// Adds a card to the database.
  /// Queries the ``BankCard`` table for the ``BankCard.number`` prior to inserting
  /// a card to ensure that the card doesn't already exist - the error message
  /// is propogated by the DbProviderResponse, as is the payload.
  Future<DbProviderResponse> addCard(BankCard bankcard) async {
    List<Map<String, dynamic>>? duplicates = await db!.query('BankCard',
        columns: ['number'], where: "number = ?", whereArgs: [bankcard.number]);

    if (duplicates.isEmpty) {
      int id = await db!.insert('BankCard', bankcard.toMapForDb());
      if (id != 0) {
        return DbProviderResponse(payload: true);
      } else {
        return DbProviderResponse(
            payload: null, errorMessage: "There was an error adding a card");
      }
    } else {
      return DbProviderResponse(
          payload: null, errorMessage: "This card already exists");
    }
  }

  Future<DbProviderResponse> getCards() async {
    // TODO: only return cards from a session (12 hours)

    List<BankCard> cards = [];

    try {
      List<Map<String, dynamic>>? maps =
          await db!.query('BankCard', columns: null);

      // ignore: unnecessary_null_comparison
      if (maps != null) {
        for (var card in maps) {
          cards.add(BankCard.fromDb(card));
        }
      }
    } catch (err) {
      print("ERROR DB PROVIDER: $err");
    }

    cards = cards.reversed.toList();

    return DbProviderResponse(payload: cards);
  }
}

// single instance - one database connection.
final dbProvider = DbProvider();
