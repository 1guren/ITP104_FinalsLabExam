import 'package:hive/hive.dart';

class FavoritesService {
  static Box<dynamic> get box => Hive.box<dynamic>('favoritesBox');

  bool isFavorite(int id) => box.containsKey(id);

  Future<bool> add({
    required int id,
    required String title,
    required String body,
  }) async {
    final Box<dynamic> favoritesBox = Hive.box<dynamic>('favoritesBox');
    if (favoritesBox.containsKey(id)) {
      return false;
    }

    await favoritesBox.put(id, <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'note': '',
    });
    return true;
  }

  List<Map<String, dynamic>> getAll() {
    return box.values
        .whereType<Map>()
        .map((dynamic value) => Map<String, dynamic>.from(value as Map))
        .toList(growable: false);
  }

  Future<void> updateNote(int id, String note) async {
    final dynamic storedValue = box.get(id);
    if (storedValue is! Map) {
      return;
    }

    final Map<String, dynamic> updatedMap =
        Map<String, dynamic>.from(storedValue);
    updatedMap['note'] = note;
    await box.put(id, updatedMap);
  }

  Future<void> remove(int id) async {
    await box.delete(id);
  }
}
