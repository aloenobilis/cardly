import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:cardly/models/bannedcountries.dart';
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
      newDb.execute('''
        CREATE TABLE BannedCountries
        (
          id INTEGER PRIMARY KEY,
          countries TEXT
        )
        ''');
    });
  }

  /// Takes an existing ``BannedCountries`` and inserts it into the database.
  /// A single record is ensured as the id property is kept on the model when
  /// it is retreived from the database and when inserted using a conflict
  /// algorithm of replace the existing record (matched by its id) is replaced.
  Future<DbProviderResponse> addBannedCountry(
      BannedCountries bannedcountries) async {
    try {
      int _ = await db!.insert('BannedCountries', bannedcountries.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (err) {
      return DbProviderResponse(
          payload: null, errorMessage: "Could not add the country.");
    }
    return DbProviderResponse(payload: true);
  }

  /// Default ``BannedCountries.countries`` to an empty list if there are
  /// no records in the database.
  /// The payload will be the first item in the List as only one record will
  /// exist in the table 'BannedCountries'.
  Future<DbProviderResponse> getBannedCountry() async {
    BannedCountries? bannedcountry;

    try {
      List<Map<String, dynamic>>? maps =
          await db!.query('BannedCountries', columns: null);

      // ignore: unnecessary_null_comparison
      if (maps != null) {
        if (maps.isEmpty) {
          return DbProviderResponse(payload: BannedCountries(countries: []));
        } else {
          bannedcountry = BannedCountries.fromDb(maps[0]);
        }
      }
    } catch (err) {
      return DbProviderResponse(
          payload: null, errorMessage: "Could not retreive banned countries");
    }

    return DbProviderResponse(payload: bannedcountry);
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
      // TODO: handle get cards with error response
      print("ERROR DB PROVIDER: $err");
    }

    cards = cards.reversed.toList();

    return DbProviderResponse(payload: cards);
  }
}

// single instance - one database connection.
final dbProvider = DbProvider();
