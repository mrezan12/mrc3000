# MR3000 📚

**Oxford 3000 Flashcard App** — A modern Flutter application designed to help you learn English vocabulary.

![Flutter](https://img.shields.io/badge/Flutter-3.38-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10-blue?logo=dart)

---

## ✨ Features

- 🎴 **Flashcard System** — Learn words by flipping cards
- 📊 **Level-Based Learning** — A1, A2, B1, B2 proficiency levels
- 🔄 **Study Modes** — Sequential, random, and level-based options
- 📝 **Review List** — Track unknown words for later practice
- 🌙 **Dark/Light Theme** — Eye-friendly dark mode support
- 📱 **Responsive Design** — Optimized for both mobile and tablet

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.38+
- Dart 3.10+

### Installation

```bash
# Clone the repository
git clone https://github.com/mrezan12/mrc3000.git

# Navigate to project directory
cd mrc3000

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── data/
│   └── words_repository.dart # Word data repository
├── models/
│   └── word.dart             # Word model
├── screens/
│   ├── home_screen.dart      # Home screen
│   ├── flashcard_screen.dart # Flashcard study screen
│   ├── level_selection_screen.dart # Level selection
│   └── review_screen.dart    # Review list screen
├── services/
│   ├── storage_service.dart  # Data persistence
│   └── theme_service.dart    # Theme management
└── widgets/
    └── flashcard.dart        # Flashcard widget
```


---

## 🛠️ Tech Stack

| Technology | Usage |
|------------|-------|
| **Flutter** | Cross-platform UI framework |
| **Material Design 3** | Modern UI components |
| **shared_preferences** | Local data persistence |

---

## 👤 Author

**Muhammed Rezan Can**

[![GitHub](https://img.shields.io/badge/GitHub-mrezan12-black?logo=github)](https://github.com/mrezan12)
