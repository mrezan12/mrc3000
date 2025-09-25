import 'dart:math';
import 'package:flutter/material.dart';
import '../data/words_repository.dart';
import '../models/word.dart';
import '../services/storage_service.dart';
import '../widgets/flashcard.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final _repo = WordsRepository();
  final _storage = StorageService();

  List<Word> _allWords = const [];
  List<Word> _filteredWords = const [];
  int _index = 0;
  bool _flipped = false;
  Set<int> _repeatSet = {};
  
  // Mod parametreleri
  String _mode = 'sequential';
  String? _level;
  String _modeTitle = 'Kelimeler';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Route arguments'ı al
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _mode = args?['mode'] ?? 'sequential';
    _level = args?['level'];
    
    // Mod başlığını belirle
    _setModeTitle();
    
    // Kelimeleri yükle
    final loaded = await _repo.loadAll();
    final repeat = await _storage.loadRepeatSet();
    
    setState(() {
      _allWords = loaded;
      _repeatSet = repeat;
    });
    
    // Kelimeleri filtrele ve hazırla
    _prepareWords();
  }

  void _setModeTitle() {
    switch (_mode) {
      case 'sequential':
        _modeTitle = 'Kelimeler (Sıralı)';
        break;
      case 'random':
        if (_level == null) {
          _modeTitle = 'Genel Rastgele';
        } else {
          _modeTitle = 'Seviye Bazlı Rastgele ($_level)';
        }
        break;
    }
  }

  void _prepareWords() {
    // Sıralı mod için hızlı yol - filtreleme yok
    if (_mode == 'sequential' && _level == null) {
      setState(() {
        _filteredWords = _allWords;
      });
      return;
    }
    
    List<Word> words = List.from(_allWords);
    
    // Seviye filtreleme
    if (_level != null) {
      words = words.where((word) => word.levels.contains(_level)).toList();
    }
    
    // Rastgele mod için karıştır
    if (_mode == 'random') {
      words.shuffle(Random());
    }
    
    setState(() {
      _filteredWords = words;
    });
  }

  Future<void> _mark({required bool known}) async {
    // Tekrar listesine ekleme - orijinal indeksi kullan
    if (!known) {
      final originalIndex = _allWords.indexOf(_filteredWords[_index]);
      if (originalIndex != -1) {
        _repeatSet.add(originalIndex);
      }
    }
    await _storage.saveRepeatSet(_repeatSet);

    if (_index >= _filteredWords.length - 1) {
      _showEndDialog();
      return;
    }
    setState(() {
      _index += 1;
      _flipped = false;
    });
  }

  void _showEndDialog() {
    final count = _repeatSet.length;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Oturum bitti'),
        content: Text(
          count == 0
              ? 'Harika! Tüm kartları bildin.'
              : 'Tekrar listesinde $count kart var.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Kapat'),
          ),
          if (_repeatSet.isNotEmpty)
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamed('/review');
              },
              child: const Text('Tekrar Listesi'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_filteredWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(_modeTitle)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                _mode == 'sequential' && _level == null
                    ? 'Kelimeler yükleniyor...'
                    : _level != null 
                        ? '$_level seviyesindeki kelimeler hazırlanıyor...'
                        : '3000 kelime hazırlanıyor...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (_mode != 'sequential' || _level != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Bu işlem birkaç saniye sürebilir',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    final w = _filteredWords[_index];

    return Scaffold(
      appBar: AppBar(
        title: Text(_modeTitle),
        actions: [
          IconButton(
            tooltip: 'Tekrar Listesi',
            onPressed: _repeatSet.isEmpty
                ? null
                : () => Navigator.pushNamed(context, '/review'),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      // Kart alanı
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kart: ${_index + 1}/${_filteredWords.length}'),
                  Text('Tekrar: ${_repeatSet.length}'),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: Flashcard(
                    front: _FrontFace(text: w.en),
                    back: _BackFace(word: w),
                    flipped: _flipped,
                    onTap: () => setState(() => _flipped = !_flipped),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),

      // Alt butonlar
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _mark(known: false),
                  icon: const Icon(Icons.close),
                  label: const Text('Bilmiyorum'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _mark(known: true),
                  icon: const Icon(Icons.check),
                  label: const Text('Biliyorum'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FrontFace extends StatelessWidget {
  const _FrontFace({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Kartı çevirmek için dokun', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _BackFace extends StatelessWidget {
  const _BackFace({required this.word});
  final Word word;

  @override
  Widget build(BuildContext context) {
    final tr = (word.tr ?? '').trim();
    final ex = (word.example ?? '').trim();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (tr.isNotEmpty)
          Text(
            tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          )
        else
          Text(
            '(Anlam eklenmedi)',
            style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
          ),
        const SizedBox(height: 12),
        if (ex.isNotEmpty)
          Text('Örnek: $ex', textAlign: TextAlign.center)
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Seviye: '),
              Text(word.levels.join(', ')),
              const Text('  |  '),
              Text(word.posRaw),
            ],
          ),
      ],
    );
  }
}