import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:extract_text/extract_text.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ExtractText', () {
    test('should extract text from .txt file', () async {
      final testFile = File('test/sample.txt');
      await testFile.writeAsString('Hello Flutter world!');

      final text = await ExtractText.fromFile(testFile.path);
      expect(text, contains('Flutter'));
    });

    test('should extract text from .docx file', () async {
      final filePath = 'test/sample.docx';

      if (File(filePath).existsSync()) {
        final text = await ExtractText.fromFile(filePath);
        expect(text.isNotEmpty, true);
      } else {
        if (kDebugMode) {
          print('Skipped .docx test (file not found)');
        }
      }
    });

    test('should throw on unsupported file', () async {
      final file = File('test/unsupported.xyz');
      await file.writeAsString('???');

      expect(() async => await ExtractText.fromFile(file.path),
          throwsA(isA<UnsupportedError>()));
    });
  });
}
