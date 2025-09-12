class Word {
  final String en;
  final String posRaw; // örn: "v.", "n."
  final List<String> levels; // örn: ["A2", "B1"]
  final String? tr; // ilk sürümde boş olabilir
  final String? example; // ilk sürümde boş olabilir

  const Word({
    required this.en,
    required this.posRaw,
    required this.levels,
    this.tr,
    this.example,
  });

  factory Word.fromMap(Map<String, dynamic> m) => Word(
    en: m['word'] as String,
    posRaw: m['pos_raw'] as String? ?? '',
    levels:
        (m['levels'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    tr: m['tr'] as String?,
    example: m['example'] as String?,
  );
}
