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
  late final Future<List<Word>> _wordsFuture = _repo.loadAll();

  int _i = 0;
  bool _flipped = false;

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
          body: Padding(
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
                Row(
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
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _flipped = false;
                            if (_i < widget.indices.length - 1) _i++;
                          });
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Tamam'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
