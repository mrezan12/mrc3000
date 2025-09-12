import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/word.dart';

class WordsRepository {
  List<Word>? _cache;

  Future<List<Word>> loadAll() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/oxford3000_words.json');
    final List list = jsonDecode(raw) as List;
    _cache = list.map((e) => Word.fromMap(e as Map<String, dynamic>)).toList();
    return _cache!;
  }
}
