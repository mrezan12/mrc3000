import 'package:flutter/material.dart';
import '../data/words_repository.dart';
import '../services/storage_service.dart';
import '../widgets/flashcard.dart';
import '../models/word.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _repo = WordsRepository();
  final _storage = StorageService();

  late Future<void> _initFuture;
  List<int> _indices = [];

  @override
  void initState() {
    super.initState();
    _initFuture = _init();
  }

  Future<void> _init() async {
    final words = await _repo.loadAll();
    final repeat = await _storage.loadRepeatSet();
    _indices = repeat.where((i) => i >= 0 && i < words.length).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (_indices.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Tekrar listesi boş.')),
          );
        }
        return _ReviewContent(indices: _indices);
      },
    );
  }
}

class _ReviewContent extends StatefulWidget {
  const _ReviewContent({required this.indices});
  final List<int> indices;

  @override
  State<_ReviewContent> createState() => _ReviewContentState();
}

class _ReviewContentState extends State<_ReviewContent> {
  final _repo = WordsRepository();
  final _storage = StorageService();
  late final Future<List<Word>> _wordsFuture = _repo.loadAll();

  int _i = 0;
  bool _flipped = false;
  Set<int> _repeatSet = {};

  @override
  void initState() {
    super.initState();
    _loadRepeatSet();
  }

  Future<void> _loadRepeatSet() async {
    final repeat = await _storage.loadRepeatSet();
    setState(() {
      _repeatSet = repeat;
    });
  }

  Future<void> _markAsKnown() async {
    // Mevcut kelimeyi tekrar listesinden çıkar
    final currentIndex = widget.indices[_i];
    _repeatSet.remove(currentIndex);
    await _storage.saveRepeatSet(_repeatSet);

    // Sonraki karta geç veya oturumu bitir
    if (_i >= widget.indices.length - 1) {
      _showEndDialog();
      return;
    }
    
    setState(() {
      _i += 1;
      _flipped = false;
    });
  }

  void _showEndDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tekrar Oturumu Bitti'),
        content: const Text('Tüm kelimeleri başarıyla tekrar ettiniz!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Ana sayfaya dön
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Word>>(
      future: _wordsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final words = snapshot.data!;
        final w = words[widget.indices[_i]];

        return Scaffold(
          appBar: AppBar(title: const Text('Tekrar Listesi')),

          // Kart alanı
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Kart: ${_i + 1}/${widget.indices.length}'),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Center(
                      child: Flashcard(
                        front: Text(
                          w.en,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        back: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if ((w.tr ?? '').isNotEmpty)
                              Text(
                                w.tr!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else
                              const Text('(Anlam eklenmedi)'),
                            const SizedBox(height: 8),
                            if ((w.example ?? '').isNotEmpty)
                              Text(
                                'Örnek: ${w.example}',
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                        flipped: _flipped,
                        onTap: () => setState(() => _flipped = !_flipped),
                      ),
                    ),
                  ),
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
                      onPressed: () {
                        setState(() {
                          _flipped = false;
                          if (_i < widget.indices.length - 1) _i++;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tekrar Gerek'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _markAsKnown,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Tamam'),
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
      },
    );
  }
}
