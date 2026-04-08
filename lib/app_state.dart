import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _bombs = (await secureStorage.getStringList('ff_bombs'))
              ?.map(int.parse)
              .toList() ??
          _bombs;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  List<int> _bombs = [];
  List<int> get bombs => _bombs;
  set bombs(List<int> value) {
    _bombs = value;
    secureStorage.setStringList(
        'ff_bombs', value.map((x) => x.toString()).toList());
  }

  void deleteBombs() {
    secureStorage.delete(key: 'ff_bombs');
  }

  void addToBombs(int value) {
    bombs.add(value);
    secureStorage.setStringList(
        'ff_bombs', _bombs.map((x) => x.toString()).toList());
  }

  void removeFromBombs(int value) {
    bombs.remove(value);
    secureStorage.setStringList(
        'ff_bombs', _bombs.map((x) => x.toString()).toList());
  }

  void removeAtIndexFromBombs(int index) {
    bombs.removeAt(index);
    secureStorage.setStringList(
        'ff_bombs', _bombs.map((x) => x.toString()).toList());
  }

  void updateBombsAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    bombs[index] = updateFn(_bombs[index]);
    secureStorage.setStringList(
        'ff_bombs', _bombs.map((x) => x.toString()).toList());
  }

  void insertAtIndexInBombs(int index, int value) {
    bombs.insert(index, value);
    secureStorage.setStringList(
        'ff_bombs', _bombs.map((x) => x.toString()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
