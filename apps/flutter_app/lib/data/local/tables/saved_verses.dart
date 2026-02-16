import 'package:drift/drift.dart';

/// Stores the user's progress on specific verses.
class SavedVerses extends Table {
  TextColumn get id => text()(); 
  
  IntColumn get book => integer()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get translation => text()();

  DateTimeColumn get nextReviewDate => dateTime()(); 
  
  // SM2 Stats
  RealColumn get sm2EaseFactor => real().withDefault(const Constant(2.5))();
  IntColumn get sm2IntervalDays => integer().withDefault(const Constant(0))();
  IntColumn get sm2RepetitionCount => integer().withDefault(const Constant(0))();

  // HLR Stats
  RealColumn get hlrStability => real().nullable()();
  RealColumn get hlrDifficulty => real().nullable()();
  IntColumn get hlrCorrectCount => integer().withDefault(const Constant(0))();
  IntColumn get hlrIncorrectCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); 

  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}