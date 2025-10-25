import 'dart:io';

import 'package:tesseract_ocr/ocr_engine_config.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class TesseractOCTExtractor {
  static List<String> supportedLanguages = ['mya', 'eng', 'tha'];
  static Future<String> performOcr(String imagePath) async {
    try {
      final tesseractConfig = OCRConfig(
        language: supportedLanguages.join('+'),
        engine: OCREngine.tesseract,
      );

      final visionConfig = OCRConfig(
        engine: OCREngine.vision,
        language: supportedLanguages.join('+'),
      );

      if (Platform.isIOS) {
        return await TesseractOcr.extractText(imagePath, config: visionConfig);
      } else {
        return await TesseractOcr.extractText(
          imagePath,
          config: tesseractConfig,
        );
      }
    } catch (e) {
      return 'Error performing OCR: $e';
    }
  }
}
