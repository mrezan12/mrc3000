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

  List<Word> _words = const [];
  int _index = 0;
  bool _flipped = false;
  Set<int> _repeatSet = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final loaded = await _repo.loadAll();
    final repeat = await _storage.loadRepeatSet();
    setState(() {
      _words = loaded;
      _repeatSet = repeat;
    });
  }

  Future<void> _mark({required bool known}) async {
    if (!known) _repeatSet.add(_index);
    await _storage.saveRepeatSet(_repeatSet);

    if (_index >= _words.length - 1) {
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
    if (_words.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final w = _words[_index];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kart: ${_index + 1}/${_words.length}'),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _mark(known: false),
                    icon: const Icon(Icons.close),
                    label: const Text('Bilmiyorum'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _mark(known: true),
                    icon: const Icon(Icons.check),
                    label: const Text('Biliyorum'),
                  ),
                ),
              ],
            ),
          ],
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
    final tr = word.tr ?? '';
    final ex = word.example ?? '';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (tr.isNotEmpty)
          Text(
            tr,
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
