import 'dart:io';

import 'package:tesseract_ocr/ocr_engine_config.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class TesseractOCTExtractor {
  Future<String> _performOcr(String imagePath, String languageCode) async {
    try {
      final tesseractConfig = OCRConfig(language: languageCode, engine: OCREngine.tesseract);

      final visionConfig = OCRConfig(
        engine: OCREngine.vision,
        language: languageCode, // Vision engine may also use language hint
      );

      if (Platform.isIOS) {
        return await TesseractOcr.extractText(imagePath, config: visionConfig);
      } else {
        return await TesseractOcr.extractText(imagePath, config: tesseractConfig);
      }
    } catch (e) {
      return 'Error performing OCR: $e';
    }
  }

  Future<String> burmeseOCRExtractor(String path) async {
    return await _performOcr(path, 'mya');
  }

  Future<String> englishOCRExtractor(String path) {
    throw UnimplementedError();
  }

  Future<String> thaiOCRExtractor(String path) async {
    return await _performOcr(path, 'tha');
  }
}
