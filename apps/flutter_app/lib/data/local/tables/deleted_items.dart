import 'package:drift/drift.dart';

import '../enums.dart';

/// Tracks IDs of items that were hard-deleted locally
/// so we can tell the server to delete them too.
class DeletedItems extends Table {
  TextColumn get itemId => text()(); 
  
  TextColumn get resourceType => textEnum<DeleteResourceType>()();

  // Defaulting to true - deleted item needs to be synced and then locally deleted.
  BoolColumn get needsSync => boolean().withDefault(const Constant(true))();
  
  @override
  Set<Column> get primaryKey => {itemId};
}
// TODO: SERVER MUST RUN A CRON JOB AND DELETE ENTITIES 
// IN THIS TABLE ON SERVER OLDER THAN N DAYS. 
// IF THE CLIENT DOES NOT SYNC FOR OVER N DAYS HIS DB GETS OVERWRITTEN.
