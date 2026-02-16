import 'package:drift/drift.dart';

/// Stores the immutable Bible text content.
/// Populated once from JSON file.
class LocalBibleVerses extends Table {
  IntColumn get id => integer().autoIncrement()(); 
  
  IntColumn get book => integer()(); 
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get textContent => text()(); 
  TextColumn get translation => text().withLength(min: 2, max: 10)(); 
  IntColumn get wordCount => integer()(); 
  
  // Prevent duplicate verses
  @override
  List<Set<Column>> get uniqueKeys => [
    {book, chapter, verse, translation}, 
  ];
}