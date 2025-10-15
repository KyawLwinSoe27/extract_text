
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class PdfExtractor {
  static Future<String> extract(String filePath) async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(filePath);
    } on PlatformException {
      if (kDebugMode) {
        print('Failed to get PDF text.');
      }
    }
    return text;
  }
}
