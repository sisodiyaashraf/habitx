import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  final results = <MapEntry<int, String>>[];
  for (final f in files) {
    final lines = f.readAsLinesSync().length;
    if (lines > 180) results.add(MapEntry(lines, f.path));
  }
  results.sort((a, b) => b.key.compareTo(a.key));
  for (final r in results) {
    // ignore: avoid_print
    print('${r.key}: ${r.value}');
  }
}
