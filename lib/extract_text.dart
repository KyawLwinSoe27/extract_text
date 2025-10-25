/// High-level convenience API for extracting text from files.
///
/// The `ExtractText` class provides a single static entry point to extract
/// text content from a file at a given filesystem `path`. The actual
/// extraction implementation is delegated to specialized extractors based
/// on the file type (PDF, DOCX, TXT) or to an OCR extractor for image
/// files.
///
/// Usage example:
///
/// ```dart
/// final text = await ExtractText.fromFile('/path/to/document.pdf');
/// print(text);
/// ```
///
/// Supported file types:
/// - PDF (`FileType.pdf`) — handled by `PdfExtractor`.
/// - DOCX (`FileType.docx`) — handled by `DocxExtractor`.
/// - TXT (`FileType.txt`) — handled by `TxtExtractor`.
/// - Image files (`FileType.image`) — handled by Tesseract OCR via
///   `TesseractOCTExtractor.performOcr`.
///
/// If the `FileTypeHelper` is unable to determine the file type or the
/// type is unsupported, `fromFile` will throw an [UnsupportedError].
library;

import 'package:extract_text/src/tesseract_ocr_extractor.dart';

import 'src/file_type_helper.dart';
import 'src/pdf_extractor.dart';
import 'src/docx_extractor.dart';
import 'src/txt_extractor.dart';

/// A small facade that selects the correct extractor for a given file.
///
/// Call [fromFile] with the path to a file to receive the extracted text as
/// a [Future<String>]. The method inspects the path to determine the
/// appropriate extractor via [FileTypeHelper.getFileType].
class ExtractText {
  /// Extracts text from the file at [path].
  ///
  /// Returns a [Future<String>] that completes with the extracted text.
  ///
  /// The returned text is implementation-dependent (extractors may try to
  /// preserve whitespace, line breaks, or other formatting). For image
  /// files, OCR is performed which may produce imperfect results depending
  /// on image quality and available trained data.
  ///
  /// Throws [UnsupportedError] if the file type cannot be handled.
  ///
  /// Example:
  ///
  /// ```dart
  /// final text = await ExtractText.fromFile('assets/sample.pdf');
  /// ```
  static Future<String> fromFile(String path) async {
    final type = FileTypeHelper.getFileType(path);

    switch (type) {
      case FileType.pdf:
        return await PdfExtractor.extract(path);
      case FileType.docx:
        return await DocxExtractor.extract(path);
      case FileType.txt:
        return await TxtExtractor.extract(path);
      case FileType.image:
        return await TesseractOCTExtractor.performOcr(path);
      case FileType.unsupported:
        throw UnsupportedError('File type not supported: $path');
    }
  }
}
