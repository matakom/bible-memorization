import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text()();
  TextColumn get friendCode => text()();
  
  IntColumn get score => integer().withDefault(const Constant(0))();

  // Algorithm Settings
  RealColumn get targetRetention => real().withDefault(const Constant(0.9))();
  RealColumn get userMemoryFactor => real().withDefault(const Constant(1.0))();

  TextColumn get language => text().withDefault(const Constant('en'))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();


  @override
  Set<Column> get primaryKey => {id};
}