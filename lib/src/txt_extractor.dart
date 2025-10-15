import 'dart:io';

class TxtExtractor {
  static Future<String> extract(String filePath) async {
    return await File(filePath).readAsString();
  }
}