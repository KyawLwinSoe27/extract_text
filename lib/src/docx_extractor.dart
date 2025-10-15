import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:xml/xml.dart';

class DocxExtractor {
  static Future<String> extract(String filePath) async {
    // Step 1: Read file bytes
    final bytes = await File(filePath).readAsBytes();

    // Step 2: Decode the ZIP (DOCX is basically a zip file)
    final archive = ZipDecoder().decodeBytes(bytes);

    // Step 3: Find the main document.xml inside the DOCX
    final documentFile = archive.files.firstWhere(
          (file) => file.name == 'word/document.xml',
      orElse: () => throw Exception('Invalid DOCX: document.xml not found'),
    );

    // Step 4: Decode the XML content
    final content = String.fromCharCodes(documentFile.content);
    final xmlDoc = XmlDocument.parse(content);

    // Step 5: Extract all text elements (<w:t>)
    final textNodes = xmlDoc.findAllElements('w:t');
    final textBuffer = StringBuffer();
    for (final node in textNodes) {
      textBuffer.write(node.innerText);
      textBuffer.write(' '); // optional spacing between words
    }

    return textBuffer.toString().trim();
  }
}
