import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _repeatKey = 'repeat_indices_v1';

  Future<Set<int>> loadRepeatSet() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_repeatKey);
    if (s == null) return <int>{};
    final List list = jsonDecode(s) as List;
    return list.map((e) => e as int).toSet();
  }

  Future<void> saveRepeatSet(Set<int> set) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_repeatKey, jsonEncode(set.toList()));
  }
}
