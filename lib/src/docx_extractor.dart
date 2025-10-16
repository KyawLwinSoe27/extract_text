import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:xml/xml.dart';

class DocxExtractor {
  static Future<String> extract(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final documentFile = archive.files.firstWhere((file) => file.name == 'word/document.xml', orElse: () => throw Exception('Invalid DOCX: document.xml not found'));

    final content = String.fromCharCodes(documentFile.content);
    final xmlDoc = XmlDocument.parse(content);

    final textNodes = xmlDoc.findAllElements('w:t');
    final textBuffer = StringBuffer();
    for (final node in textNodes) {
      textBuffer.write(node.innerText);
      textBuffer.write(' ');
    }

    return textBuffer.toString().trim();
  }
}
