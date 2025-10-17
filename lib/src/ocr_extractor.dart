import 'dart:io';
import 'package:extract_text/src/tesseract_ocr_extractor.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrExtractor {
  static TesseractOCTExtractor tesseractOCTExtractor = TesseractOCTExtractor();

  static Future<String> extract(String filePath, {TextRecognitionScript languageScript = TextRecognitionScript.latin}) async {
    final inputImage = InputImage.fromFile(File(filePath));
    final textRecognizer = TextRecognizer(script: languageScript);

    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    return recognizedText.text;
  }

  static Future<String> extractTextAutoLanguage(String filePath) async {
    final inputImage = InputImage.fromFile(File(filePath));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    String languageCode = await detectLanguage(recognizedText.text);
    TextRecognitionScript script;
    switch (languageCode) {
      case 'th':
        script = TextRecognitionScript.latin;
        break;
      case 'ja':
        script = TextRecognitionScript.japanese;
        break;
      case 'zh':
        script = TextRecognitionScript.chinese;
        break;
      case 'ko':
        script = TextRecognitionScript.korean;
        break;
      case 'hi':
        script = TextRecognitionScript.devanagiri;
        break;
      case 'en':
      default:
        script = TextRecognitionScript.latin;
    }
    String rawText = '';

    if (languageCode == 'th') {
      rawText = await tesseractOCTExtractor.thaiOCRExtractor(filePath);
    } else if (languageCode == 'my') {
      rawText = await tesseractOCTExtractor.burmeseOCRExtractor(filePath);
    } else {
      rawText = await OcrExtractor.extract(filePath, languageScript: script);
    }
    return rawText;
  }

  static Future<String> detectLanguage(String text) async {
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    final languageCode = await languageIdentifier.identifyLanguage(text);
    await languageIdentifier.close();
    return languageCode; // 'th' for Thai, 'en' for English, etc.
  }
}