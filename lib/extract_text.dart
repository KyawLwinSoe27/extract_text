import 'package:extract_text/src/ocr_extractor.dart';

import 'src/file_type_helper.dart';
import 'src/pdf_extractor.dart';
import 'src/docx_extractor.dart';
import 'src/txt_extractor.dart';

class ExtractText {
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
        return await OcrExtractor.extract(path);
      case FileType.unsupported:
      throw UnsupportedError('File type not supported: $path');
    }
  }
}
