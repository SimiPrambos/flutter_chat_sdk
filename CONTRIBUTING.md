# Contributing to `flutter_chat_sdk`

Thank you for your interest in contributing! All skill levels are welcome.

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold it.

---

## Reporting Bugs

Use the GitHub issue tracker. Include:

- Flutter version (`flutter --version`)
- Package version
- Your adapter type (HTTP, WebSocket, Firebase, etc.)
- Minimal reproducible example
- Full error message and stack trace
- Operating system and target platform (iOS / Android / Web / Desktop)

---

## Proposing Features

Open an issue first to discuss the feature before writing code. Describe:

1. The problem you are solving
2. Your proposed API or design
3. Alternatives you considered

This avoids duplicate work and ensures the direction fits the package goals.

---

## Development Setup

1. Clone the repo
2. Install Flutter SDK (see `pubspec.yaml` for the minimum version)
3. Run `flutter pub get`
4. Run tests: `flutter test`
5. Run analysis: `dart analyze lib/`

Regenerate Drift database code after modifying schema files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Code Style

This project uses [very_good_analysis](https://pub.dev/packages/very_good_analysis) lint rules. All PRs must pass `dart analyze`.

Key conventions:

- Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Public API members must have doc comments
- Prefer `final` everywhere applicable
- Avoid dynamic typing; use generics and typed collections

---

## Writing Tests

- Use `MockChatAdapter` and `FakeChatDatabase` from `test/helpers/`
- Test behavior, not implementation
- Run `flutter test` to verify all tests pass

---

## Writing a Backend Adapter

Implement `ChatAdapter` and consider publishing it as a separate package. Name convention: `flutter_chat_sdk_firebase`, `flutter_chat_sdk_supabase`, etc.

A minimal adapter:

```dart
import 'package:flutter_chat_sdk/flutter_chat_sdk.dart';

class MyAdapter extends HttpChatAdapter {
  @override
  String get name => 'MyAdapter';

  @override
  Future<void> initialize() async { /* set up your client */ }

  @override
  Future<SyncResult> initialSync() async { /* ... */ }

  @override
  Future<SyncResult> incrementalSync(String sinceToken) async { /* ... */ }

  @override
  Future<Message> sendMessage(SendMessageParams params) async { /* ... */ }

  // Implement remaining ChatRepository methods...
}
```

---

## Pull Request Process

1. Fork the repo and create a branch from `main`
2. Make your changes with tests
3. Ensure `dart analyze` and `flutter test` both pass
4. Update `CHANGELOG.md`
5. Open a PR describing what and why
6. Link the related issue (e.g. `Closes #42`) in the PR description

PRs without tests or with a failing analyzer will not be merged.

---

## Commit Messages

Use imperative, present tense: "add feature" not "added feature". Keep the first line under 72 characters.

Examples:

- `add reaction persistence to sync engine`
- `fix unread count not resetting on markAsRead`
- `refactor outbound queue to use exponential backoff`

One logical change per commit. If a commit needs a long explanation, add a blank line after the subject and write a body.

---

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
