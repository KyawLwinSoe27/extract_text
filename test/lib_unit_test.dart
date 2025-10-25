import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:extract_text/src/file_type_helper.dart';
import 'package:extract_text/src/docx_extractor.dart';
import 'package:extract_text/src/txt_extractor.dart';
import 'package:extract_text/src/pdf_extractor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FileTypeHelper', () {
    test('detects common extensions (case-insensitive)', () {
      expect(FileTypeHelper.getFileType('a.PDF'), FileType.pdf);
      expect(FileTypeHelper.getFileType('b.docx'), FileType.docx);
      expect(FileTypeHelper.getFileType('c.TxT'), FileType.txt);
      expect(FileTypeHelper.getFileType('image.JPG'), FileType.image);
      expect(FileTypeHelper.getFileType('unknown.bin'), FileType.unsupported);
    });

    test('handles paths without dot gracefully (treated as extension)', () {
      // Current implementation treats the whole path as extension; assert behavior
      expect(FileTypeHelper.getFileType('no_extension'), FileType.unsupported);
    });
  });

  group('TxtExtractor', () {
    test('reads a text file contents', () async {
      final file = File('test/sample.txt');
      await file.writeAsString('Line1\nLine2');

      final content = await TxtExtractor.extract(file.path);
      expect(content, contains('Line1'));
      expect(content, contains('Line2'));
    });
  });

  group('DocxExtractor', () {
    test('extracts text from sample.docx if present', () async {
      final path = 'test/sample.docx';
      if (!File(path).existsSync()) {
        if (kDebugMode) {
          print('Skipping DOCX extractor test (sample.docx not found)');
        }
        return;
      }

      final text = await DocxExtractor.extract(path);
      expect(text, isNotNull);
      expect(text.trim().isNotEmpty, true);
    });
  });

  group('PdfExtractor (plugin-dependent)', () {
    test('extracts text from sample.pdf when plugin works', () async {
      final path = 'test/sample.pdf';
      if (!File(path).existsSync()) {
        if (kDebugMode) {
          print('Skipping PDF extractor test (sample.pdf not found)');
        }
        return;
      }

      // Mock the MethodChannel used by read_pdf_text plugin to avoid MissingPluginException
      const channel = MethodChannel('read_pdf_text');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'getPDFtext') {
              // return a deterministic sample string for the test
              return 'Mocked PDF extracted text';
            }
            return null;
          });

      try {
        final text = await PdfExtractor.extract(path);
        expect(text, isA<String>());
        expect(text, contains('Mocked PDF'));
      } finally {
        // Clear the mock handler so other tests are unaffected
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null);
      }
    });
  });
}
