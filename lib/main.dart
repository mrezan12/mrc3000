import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/review_screen.dart';
import 'screens/level_selection_screen.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().loadTheme();
  runApp(const FlashcardsApp());
}

class FlashcardsApp extends StatelessWidget {
  const FlashcardsApp({super.key});

  static const _seedColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService().themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MR3000 - Oxford 3000 Flashcards',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: _seedColor,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: _seedColor,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeMode,
          initialRoute: '/',
          routes: {
            '/': (_) => const HomeScreen(),
            '/study': (_) => const FlashcardScreen(),
            '/review': (_) => const ReviewScreen(),
            '/level-selection': (_) => const LevelSelectionScreen(),
          },
        );
      },
    );
  }
}
