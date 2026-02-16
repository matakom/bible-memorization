import 'package:drift/drift.dart';
import 'saved_verses.dart';
import '../enums.dart';

/// Log of every single game played. 
class Exercises extends Table {
  TextColumn get id => text()();
  
  TextColumn get savedVerseId => text().references(SavedVerses, #id)(); 
  
  // 0.0 to 1.0 (Accuracy)
  RealColumn get rawScore => real()(); 
  
  TextColumn get gameType => textEnum<GameType>()(); 
  IntColumn get durationMs => integer()(); 
  DateTimeColumn get performedAt => dateTime().withDefault(currentDateAndTime)();
  
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}