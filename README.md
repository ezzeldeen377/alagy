# Alagy

A Flutter application implementing clean architecture principles.

## Project Structure

The project follows a modular architecture with clear separation of concerns:

```
lib/
├── core/                  # Core functionality
│   ├── common/            # Shared utilities and constants
│   ├── l10n/              # Localization
│   └── theme/             # Theme configuration
│
├── features/              # Feature modules
│   └── settings/          # Settings feature
│       ├── cubit/         # State management
│       │   ├── app_settings_cubit.dart
│       │   └── app_settings_state.dart
│       └── presentation/  # UI components
│           └── settings_screen.dart
│
└── main.dart             # Application entry point
```

## Layer Guidelines

### Core Layer

Contains base classes, interfaces, and utilities used across the application:

- **common**: Shared utilities, constants, and base classes
- **l10n**: Localization resources and configurations
- **theme**: App-wide theme configuration and styling

### Feature Modules

Each feature module is self-contained and follows clean architecture principles:

- **presentation**: UI components and widgets
- **cubit**: State management using Flutter Bloc

### Current Features

#### Settings

Manages application-wide settings:

- Theme switching (Light/Dark mode)
- Language selection (English/Arabic)

## Development Guidelines

### State Management

- Uses Flutter Bloc (Cubit) for predictable state management
- Each feature maintains its own state and business logic

### Localization

- Supports multiple languages (English, Arabic)
- Uses Flutter's built-in localization system
- Language resources stored in .arb files

### Theming

- Consistent theme implementation across the app
- Supports light and dark modes
- Theme configurations centralized in theme layer

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Dependencies

- flutter_bloc: State management
- flutter_screenutil: Responsive UI
- flutter_localizations: Internationalization