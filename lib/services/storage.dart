import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

const String _DATABASE_FILE = 'twake.db';

class Storage {
  static Storage _storage;
  StoreRef _authStore = intMapStoreFactory.store('auth');
  StoreRef _profileStore = intMapStoreFactory.store('profile');
  StoreRef _channelStore = stringMapStoreFactory.store('channel');
  StoreRef _messageStore = stringMapStoreFactory.store('message');
  Database _db;

  final logger = Logger();

  factory Storage() {
    if (_storage == null) {
      _storage = Storage._();
    }
    return _storage;
  }

  Storage._();

  Future<void> initDb() async {
    // Initialize database
    // First get application directory on device
    final dir = await getApplicationDocumentsDirectory();
    // create application directory if doesn't exist
    await dir.create(recursive: true);
    // join database file name with application directory path
    final dbPath = join(dir.path, _DATABASE_FILE);
    // create database file in application directory
    this._db = await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<Map<String, dynamic>> load({
    StorageType type,
    dynamic key,
  }) async {
    StoreRef storeRef = _mapTypeToStore(type);
    return await storeRef.record(key).get(this._db);
  }

  Future<void> store({
    JsonSerializable item,
    StorageType type,
    dynamic key,
  }) async {
    StoreRef storeRef = _mapTypeToStore(type);
    storeRef.record(key).put(
          this._db,
          item.toJson(),
          merge: true,
        );
  }

  Future<void> clean({
    StorageType type,
    dynamic key,
  }) async {
    StoreRef storeRef = _mapTypeToStore(type);
    storeRef.record(key).delete(_db);
  }

  StoreRef _mapTypeToStore(StorageType type) {
    StoreRef storeRef;
    if (type == StorageType.Auth)
      storeRef = _authStore;
    else if (type == StorageType.Profile)
      storeRef = _profileStore;
    else if (type == StorageType.Channel)
      storeRef = _channelStore;
    else if (type == StorageType.Message)
      storeRef = _messageStore;
    else
      throw 'Storage type does not exist';
    return storeRef;
  }
}

enum StorageType {
  Auth,
  Profile,
  Channel,
  Message,
}
