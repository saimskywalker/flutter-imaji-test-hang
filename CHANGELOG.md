# Changelog

## 0.1.1

- Documentation: install from pub.dev. The README said the package was not
  published yet and steered readers to a git dependency that tracks `main`;
  it now leads with `dart pub add --dev imaji_test_hang` and
  `dart pub global activate imaji_test_hang`, keeps the git form only for
  unreleased `main`, and both CI snippets install from pub.dev. Added pub.dev
  version and points badges.
- Documentation: corrected the per-test timeout claim. The README and the
  library documentation said the timeout cannot fire because a wedged isolate
  runs no timers. It does fire: `package:test` arms it in the root zone,
  outside the fake clock. The real problem is that a `testWidgets` test gets
  ten minutes under `flutter test` (none under `flutter run`), so a hang is
  reported late, per stuck test, and some hangs never reach it.
- Documentation: the two rules have different scopes, and the docs now say so.
  `awaited-teardown-in-run-async` applies inside a `runAsync(...)` closure
  wherever it appears, including a `setUp` with no `testWidgets` around it;
  `awaited-real-async-in-test-body` applies inside a widget test body and
  outside `runAsync`. A test now pins the first scope.
- Added `example/example.md`, pub.dev `topics`, and dartdoc for the
  `HangRules` and `Violation` constructors.
- `--version` reports 0.1.1.

## 0.1.0

First release.

- Two rules, scoped to blocks by a brace-depth scan rather than a line match:
  an awaited player teardown inside a `runAsync` closure (wherever that closure
  appears, not only in a widget test body), and awaited real-event-loop work
  (disk I/O, `path_provider`) inside a widget test body but outside
  `runAsync`.
- Every pattern list is replaceable from the command line, and passing an
  empty list disables the rule that uses it.
- `// no-hang-check: <reason>` suppresses one line; `--ignore-marker` changes
  the text. A blank `--ignore-marker` is refused with exit `2`: every line
  contains the empty string, so a blank marker would suppress every finding
  and report a clean scan. A padded marker is trimmed, matching how the
  pattern lists are normalised.
- Exit codes: `0` clean, `1` violations, `2` bad usage.
- Published as `imaji_test_hang` (repository
  `saimskywalker/flutter-imaji-test-hang`), renamed from `test_hang_guard`.
  The library import is `package:imaji_test_hang/imaji_test_hang.dart`. A
  global install also puts a `test_hang_guard` command on `PATH` alongside
  `imaji_test_hang`, so existing CI steps that call the old name keep working.
