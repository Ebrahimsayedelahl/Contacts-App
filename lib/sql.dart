import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:contacts/model.dart';

final String columnId = 'id';
final String columnName = 'Name';
final String columnNumber = 'Number';
final String columnURL = 'url';
final String contactTable = 'contact_table';

class Sql {
  late Database db;

  static final Sql instance = Sql._internal();

  factory Sql() {
    return instance;
  }

  Sql._internal();

  Future open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'contact.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $contactTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL,
            $columnNumber TEXT NOT NULL,
            $columnURL TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<Contacts> insertContact(Contacts contacts) async {
    contacts.id = await db.insert(contactTable, contacts.toMap());
    return contacts;
  }

  Future<int> updateContacts(Contacts contacts) async {
    return await db.update(
      contactTable,
      contacts.toMap(),
      where: '$columnId = ?',
      whereArgs: [contacts.id],
    );
  }

  Future<int> deleteContact(int id) async {
    return await db.delete(
      contactTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Contacts>> getAllContacts() async {
    List<Map<String, dynamic>> contactsMaps = await db.query(contactTable);
    if (contactsMaps.length == 0) {
      return [];
    } else {
      List<Contacts> contacts = [];
      for (var element in contactsMaps) {
        contacts.add(Contacts.fromMap(element));
      }
      return contacts;
    }
  }

  Future close() async => db.close();
}