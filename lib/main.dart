import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/review_screen.dart';
import 'screens/level_selection_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oxford 3000 - Flashcards',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/study': (_) => const FlashcardScreen(),
        '/review': (_) => const ReviewScreen(),
        '/level-selection': (_) => const LevelSelectionScreen(),
      },
    );
  }
}
