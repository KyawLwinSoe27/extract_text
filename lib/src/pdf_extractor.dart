/// Simple PDF text extractor using the `read_pdf_text` plugin.
///
/// The `PdfExtractor` class provides a small convenience wrapper around the
/// `read_pdf_text` plugin to extract text from PDF files on the local
/// filesystem. It is designed for straightforward usage where the entire
/// PDF content can be loaded into memory. For very large PDFs consider a
/// streaming approach if available.
///
/// Behavior and errors:
/// - Returns the extracted text as a [String]. If extraction fails the
///   implementation currently returns an empty string and logs a message in
///   debug mode. The underlying plugin may throw [PlatformException], which
///   is caught by this helper.
/// - Make sure the `read_pdf_text` plugin is configured for your target
///   platforms and any necessary native setup has been completed.
///
/// Example:
///
/// ```dart
/// final text = await PdfExtractor.extract('/path/to/document.pdf');
/// print(text);
/// ```
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class PdfExtractor {
  /// Extracts text from the PDF at [filePath].
  ///
  /// Returns a [Future<String>] that completes with the extracted text.
  /// If the underlying PDF extraction fails due to a platform error this
  /// method returns an empty string and optionally logs a debug message.
  ///
  /// Note: the `read_pdf_text` plugin may throw [PlatformException] on
  /// failures; this method catches that exception and keeps the API simple
  /// for callers.
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
