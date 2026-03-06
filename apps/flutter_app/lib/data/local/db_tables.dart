import 'package:drift/drift.dart';
import 'package:flutter_app/data/models/practice_feedback.dart';

class SavedVerses extends Table {
  TextColumn get id => text()(); 
  
  IntColumn get book => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get translation => text()();
  
  TextColumn get verseText => text().named('text')(); 
  
  // General SRS
  IntColumn get repetitionCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextReviewDate => dateTime()(); 
  DateTimeColumn get lastReviewDate => dateTime().nullable()();
  
  // SM-2 Stats
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  RealColumn get baseComplexity => real().withDefault(const Constant(0.0))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); 
  DateTimeColumn get deletedAt => dateTime().nullable()(); 
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Exercises extends Table {
  TextColumn get id => text()();
  
  TextColumn get verseId => text().references(SavedVerses, #id)(); 
  
  IntColumn get grade => integer()();
  TextColumn get exerciseType => textEnum<GameType>()();  
  IntColumn get durationSeconds => integer()();

  DateTimeColumn get performedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Friendships extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get friendId => text()();
  
  TextColumn get friendFirstName => text()();
  TextColumn get friendLastName => text()();

  TextColumn get status => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, friendId}, 
  ];
}

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();

  TextColumn get friendCode => text().nullable()();
  
  TextColumn get language => text().withDefault(const Constant('cz'))(); 

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}