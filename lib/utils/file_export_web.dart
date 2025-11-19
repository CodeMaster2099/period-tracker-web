import 'dart:convert';
import 'dart:html' as html;

Future<String> saveFile(String contents, {String filename = 'pt_export.json'}) async {
  final bytes = const Utf8Encoder().convert(contents);
  final blob = html.Blob([bytes], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement;
  anchor.href = url;
  anchor.download = filename;
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
  return filename;
}
