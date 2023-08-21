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
  // ignore: non_constant_identifier_names
  final int SESSION_LENGTH_HOURS = 8;

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
  /// Checks if the ``BankCard.country`` is in the "BannedCountries" table.
  Future<DbProviderResponse> addCard(BankCard bankcard) async {
    List<Map<String, dynamic>>? duplicates = await db!.query('BankCard',
        columns: ['number'], where: "number = ?", whereArgs: [bankcard.number]);

    if (duplicates.isEmpty) {
      DbProviderResponse response = await getBannedCountry();

      if (response.payload.countries.contains(bankcard.country)) {
        // error: cards country is in banned countries
        return DbProviderResponse(
            payload: null, errorMessage: "The card's country is banned.");
      } else {
        int id = await db!.insert('BankCard', bankcard.toMapForDb());

        if (id != 0) {
          return DbProviderResponse(payload: true);
        } else {
          return DbProviderResponse(
              payload: null, errorMessage: "There was an error adding a card");
        }
      }
    } else {
      return DbProviderResponse(
          payload: null, errorMessage: "This card already exists");
    }
  }

  /// Gets all cards from the database within a sessions time frame,
  /// see ```SESSION_LENGTH_HOURS``` for setting the session length.
  Future<DbProviderResponse> getCards() async {
    List<BankCard> cards = [];

    try {
      List<Map<String, dynamic>>? maps =
          await db!.query('BankCard', columns: null);

      // ignore: unnecessary_null_comparison
      if (maps != null) {
        DateTime now = DateTime.now();
        DateTime start = DateTime(now.year, now.month, now.day,
            now.hour - SESSION_LENGTH_HOURS, now.minute, now.second);

        for (var card in maps) {
          BankCard bankcard = BankCard.fromDb(card);
          if (bankcard.created!.isAfter(start)) {
            cards.add(BankCard.fromDb(card));
          }
        }
      }
    } catch (err) {
      return DbProviderResponse(
          payload: null, errorMessage: "Could not retreive cards");
    }

    cards = cards.reversed.toList();

    return DbProviderResponse(payload: cards);
  }
}

// single instance - one database connection.
final dbProvider = DbProvider();
