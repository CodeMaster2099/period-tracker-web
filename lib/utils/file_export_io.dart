import 'dart:io';
import 'package:path/path.dart' as p;

Future<String> saveFile(String contents, {String filename = 'pt_export.json'}) async {
  final now = DateTime.now();
  final name = filename.replaceAll('.json', '') + '_${now.toIso8601String()}.json';
  final file = File(p.join(Directory.current.path, name));
  await file.writeAsString(contents, flush: true);
  return file.path;
}
