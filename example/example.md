# imaji_test_hang examples

## From the command line

Add it to the package whose tests it guards, then run it before `flutter test`:

```bash
dart pub add --dev imaji_test_hang
dart run imaji_test_hang            # scans test/
```

Given this `test/player_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('stops the player', (tester) async {
    await tester.pumpWidget(const PlayerScreen());
    await tester.runAsync(() async {
      await audioPlayer.dispose();
    });
  });

  testWidgets('loads the draft', (tester) async {
    final dir = await getApplicationDocumentsDirectory();
  });
}
```

it exits `1` and writes this to stderr:

```
imaji_test_hang: 2 pattern(s) that can WEDGE THE TEST ISOLATE and hang the whole suite with no error.

test/player_test.dart:7  [awaited-teardown-in-run-async]
  await audioPlayer.dispose();
  A player built under the fake clock finishes its teardown only when that clock advances. runAsync runs on the real event loop and never advances it, so this await never returns. Drop the await — unawaited(...) — and let pump() drive the teardown.

test/player_test.dart:12  [awaited-real-async-in-test-body]
  final dir = await getApplicationDocumentsDirectory();
  Real disk or plugin work runs on the real event loop, which pump() does not advance — this await never returns. Either stub the dependency so the test touches no disk, or wrap the call in tester.runAsync.

If one of these is genuinely safe, append  // no-hang-check: <reason>  to the line.
```

With the teardown fixed — `unawaited(audioPlayer.dispose());` followed by
`await tester.pump();` — and the draft test stubbed, it exits `0`:

```
imaji_test_hang: 1 file(s) scanned, no hang patterns found.
```

Other invocations:

```bash
dart run imaji_test_hang test integration_test     # several roots
dart run imaji_test_hang test/player_test.dart     # one file
dart run imaji_test_hang \
  --async-symbol=DraftStore \
  --test-function=testWidgets --test-function=testWidgetsWithHarness \
  test
```

Exit codes: `0` clean, `1` violations found, `2` bad usage or a missing path.

## From Dart

The library scans source held in memory, or walks directories the way the CLI
does:

```dart
import 'dart:io';

import 'package:imaji_test_hang/imaji_test_hang.dart';

void main() {
  // Scan source you already hold: an editor buffer, a fixture, a diff.
  const source = '''
testWidgets('stops the player', (tester) async {
  await tester.runAsync(() async {
    await audioPlayer.dispose();
  });
});
''';
  final violations =
      scanLines('player_test.dart', source.split('\n'), HangRules());
  for (final v in violations) {
    print('${v.file}:${v.line} [${v.rule}]');
  }

  // Or scan directories the way the CLI does, with your own rule set. A list
  // you pass replaces its default; an empty list turns that rule off.
  exitCode = run(
    paths: ['test'],
    rules: HangRules(
      asyncSymbols: ['DraftStore'],
      testFunctions: ['testWidgets', 'testWidgetsWithHarness'],
    ),
    out: stdout,
    err: stderr,
  );
}
```
