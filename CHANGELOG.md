# Changelog

## Unreleased

- Renamed from `test_hang_guard` to `imaji_test_hang` (repository
  `saimskywalker/flutter-imaji-test-hang`). The library import is now
  `package:imaji_test_hang/imaji_test_hang.dart`. A global install still puts
  a `test_hang_guard` command on `PATH` alongside `imaji_test_hang`, so
  existing CI steps that call the old name keep working. The
  `// no-hang-check` marker is unchanged.
- Refuse a blank `--ignore-marker` instead of accepting it. Every line
  contains the empty string, so a blank marker suppressed every finding and
  the scan still reported "no hang patterns found" — a gate reporting clean
  because it had been switched off. It now exits 2 as bad usage. A padded
  marker is trimmed, matching how the pattern lists are normalised.

## 0.1.0

First release.

- Two rules, both scoped to a widget test body by a brace-depth scan rather
  than a line match: an awaited player teardown inside `tester.runAsync`, and
  awaited real-event-loop work (disk I/O, `path_provider`) inside the test
  body itself.
- Every pattern list is replaceable from the command line, and passing an
  empty list disables the rule that uses it.
- `// no-hang-check: <reason>` suppresses one line; `--ignore-marker` changes
  the text.
- Exit codes: `0` clean, `1` violations, `2` bad usage.
