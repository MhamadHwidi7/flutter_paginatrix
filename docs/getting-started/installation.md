# Installation

This guide will help you install and set up Flutter Paginatrix in your Flutter project.

## Requirements

Before installing Flutter Paginatrix, ensure you have:

- **Flutter SDK**: `>=3.22.0`
- **Dart SDK**: `>=3.2.0 <4.0.0`

## Installation Steps

### 1. Add Dependency

Add `flutter_paginatrix` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
```

### 2. Optional Dependencies

If you're using Dio for HTTP requests (recommended), add it:

```yaml
dependencies:
  flutter_paginatrix: ^1.0.0
  dio: ^5.4.0
```

### 3. Install Packages

Run the following command to install the package:

```bash
flutter pub get
```

## Verify Installation

To verify the installation, try importing the package:

```dart
import 'package:flutter_paginatrix/flutter_paginatrix.dart';
```

If there are no errors, the installation was successful!

## Next Steps

- Read the [Quick Start Guide](quick-start.md) to get started
- Check out [Core Concepts](core-concepts.md) to understand the package architecture
- Explore the [Examples](../examples/) to see real-world usage

## Troubleshooting

### Common Installation Issues

**Issue:** `flutter pub get` fails with version conflict

**Solution:** Ensure your Flutter SDK version is `>=3.22.0`:
```bash
flutter --version
```

**Issue:** Import errors after installation

**Solution:** 
1. Run `flutter clean`
2. Run `flutter pub get`
3. Restart your IDE

**Issue:** Build errors related to code generation

**Solution:** Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Dependencies

Flutter Paginatrix depends on:

- `flutter_bloc: ^9.1.1` - State management (included, no need to add separately)
- `freezed_annotation: ^2.4.1` - Immutability
- `equatable: ^2.0.7` - Value equality
- `json_annotation: ^4.9.0` - JSON serialization
- `skeletonizer: ^2.1.0` - Skeleton loading effects

All dependencies are automatically installed when you add `flutter_paginatrix`.


