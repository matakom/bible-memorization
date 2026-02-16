import 'package:drift/drift.dart';

class BibleBooks extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get translation => text()();
  IntColumn get totalChapters => integer()();
  @override
  Set<Column> get primaryKey => {id, translation};
}