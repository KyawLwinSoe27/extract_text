import 'package:extract_text/extract_text.dart';
import 'package:flutter/foundation.dart';

void main() async {
  final filePath = '/storage/emulated/0/Download/sample.pdf';
  try {
    final text = await ExtractText.fromFile(filePath);
    if (kDebugMode) {
      print('Extracted text:');
    }
    if (kDebugMode) {
      print(text);
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
  }
}