import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/word.dart';

class WordsRepository {
  List<Word>? _cache;

  Future<List<Word>> loadAll() async {
    if (_cache != null) return _cache!;
    
    // JSON'u yükle
    final raw = await rootBundle.loadString('assets/oxford3000_words_tr.json');
    
    // Arka planda JSON işleme - UI'yi bloklamaz
    _cache = await compute(_parseWords, raw);
    return _cache!;
  }

  // Arka planda çalışacak JSON parsing fonksiyonu
  static List<Word> _parseWords(String raw) {
    final List list = jsonDecode(raw) as List;
    return list.map((e) => Word.fromMap(e as Map<String, dynamic>)).toList();
  }
}
