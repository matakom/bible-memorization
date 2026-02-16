import 'package:drift/drift.dart';
import '../enums.dart';

class Friendships extends Table {
  TextColumn get id => text()();
  
  TextColumn get friendId => text()();
  TextColumn get friendFirstName => text()();
  TextColumn get friendLastName => text()();
  IntColumn get friendScore => integer().withDefault(const Constant(0))();
  TextColumn get status => textEnum<FriendshipStatus>()();  
  BoolColumn get isOutgoing => boolean()();
  
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}