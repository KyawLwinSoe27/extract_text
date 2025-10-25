/// DOCX (Microsoft Word) extractor.
///
/// This module reads a `.docx` file (which is a ZIP archive of XML
/// documents), locates `word/document.xml`, parses the XML and returns the
/// concatenation of text nodes. It uses `archive` to decode the ZIP and
/// `xml` to parse the WordprocessingML document.
///
/// Behavior and error modes:
/// - On success returns a `String` containing text found in the document's
///   `<w:t>` text nodes. Nodes are concatenated with a single space between
///   runs; the extractor does not preserve complex Word formatting.
/// - Throws an [Exception] if `word/document.xml` is not present in the
///   archive (the file is not a valid DOCX document).
/// - May throw [FileSystemException] when reading the file, [Utf8Decoder]
///   related errors when decoding bytes to string, or [XmlParserException]
///   when parsing malformed XML.
///
/// Usage example:
///
/// ```dart
/// final text = await DocxExtractor.extract('assets/sample.docx');
/// print(text);
/// ```
library;

import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:xml/xml.dart';

class DocxExtractor {
  /// Extracts text content from the DOCX file at [filePath].
  ///
  /// This function reads the file as bytes, decodes the ZIP entries, and
  /// parses `word/document.xml`. It returns the concatenated text of all
  /// `<w:t>` elements found in the document. The approach is simple and
  /// effective for extracting readable text but does not attempt to map
  /// styles, footnotes, headers/footers, or other advanced Word features.
  static Future<String> extract(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final documentFile = archive.files.firstWhere(
      (file) => file.name == 'word/document.xml',
      orElse: () => throw Exception('Invalid DOCX: document.xml not found'),
    );

    final content = utf8.decode(documentFile.content);
    final xmlDoc = XmlDocument.parse(content);

    final textNodes = xmlDoc.findAllElements('t', namespace: '*');

    final textBuffer = StringBuffer();
    for (final node in textNodes) {
      textBuffer.write(node.innerText);
      textBuffer.write(' ');
    }

    return textBuffer.toString().trim();
  }
}
