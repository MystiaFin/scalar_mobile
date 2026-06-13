# scalar_mobile

A Flutter mobile client for viewing financial transactions fetched from a configurable REST API. Transactions are grouped by date with category-specific icons, and the app features a Catppuccin-themed dark/light mode toggle.

## Features

- **Configurable API endpoint** — set any base URL via the Settings dialog; persists across launches
- **Transaction feed** — fetches and displays transactions grouped by date in a scrollable list
- **Category icons** — each transaction shows a contextual icon (food, transport, shopping, health, entertainment, etc.)
- **Dark / Light theme** — toggle between Catppuccin Mocha (dark) and Catppuccin Latte (light); preference is saved
- **Multi-platform** — runs on Android, iOS, Web, Linux, macOS, and Windows

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Dart 3.x |
| Framework | Flutter (Material Design 3) |
| HTTP | `http` |
| Local storage | `shared_preferences` |
| Theme | Catppuccin (Mocha / Latte) |
| Linting | `flutter_lints` |

## Architecture

```
lib/
├── main.dart                     # App entry point, theme wiring
├── models/
│   └── transaction.dart          # Transaction data model
├── screens/
│   └── home_page.dart            # Main screen: settings, fetch, list
├── services/
│   ├── api_client.dart           # Generic HTTP GET/POST client
│   ├── settings_service.dart     # Persists base URL via SharedPreferences
│   └── transaction_service.dart  # Fetches & deserializes transactions
├── theme/
│   ├── app_colors.dart           # Abstract color scheme interface
│   ├── app_theme.dart            # Builds Material3 ThemeData from palette
│   ├── theme_notifier.dart       # Theme toggle state + persistence
│   ├── dark/mocha.dart           # Catppuccin Mocha palette
│   └── light/latte.dart          # Catppuccin Latte palette
└── widgets/
    └── transaction_card.dart     # Individual transaction row widget
```

The app expects a backend serving `GET /api/transactions` returning a JSON array of objects with the shape:

```json
[
  {
    "id": 1,
    "merchant": "Starbucks",
    "category": "food & drink",
    "is_expense": true,
    "date": "2025-06-13",
    "confirmed": true
  }
]
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK ^3.12.2)
- Platform-specific tooling (Android Studio / Xcode / Linux Dev tools)

### Run in development

```bash
flutter pub get
flutter run
```

Target a specific platform:

```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
flutter run -d linux
```

### Build for release

```bash
flutter build apk          # Android
flutter build ios           # iOS (macOS only)
flutter build web           # Web
flutter build linux         # Linux
flutter build macos         # macOS
flutter build windows       # Windows
```

### Run tests

```bash
flutter test
```

### Lint

```bash
flutter analyze
```
