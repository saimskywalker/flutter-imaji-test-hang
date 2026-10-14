/// Finds the Flutter test patterns that deadlock the test isolate.
///
/// Every other mistake in a test file fails loudly. This family does not — it
/// DEADLOCKS. The suite stops producing output and sits there, and a hang is
/// indistinguishable from a slow run, so nobody learns which test did it or
/// even that a test did it. The per-test timeout is little help: it does fire,
/// but a `testWidgets` test gets ten minutes under `flutter test`, none under
/// `flutter run`, and some hangs never reach it. Until it fires, or the CI job
/// timeout does, nothing is reported.
///
/// Point [run] at a directory of tests, or call [scanLines] on source you
/// already hold.
library;

export 'src/rules.dart';
export 'src/runner.dart';
export 'src/scanner.dart';
export 'src/violation.dart';
