import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrExtractor {
  static Future<String> extract(String filePath) async {
    final inputImage = InputImage.fromFile(File(filePath));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    return recognizedText.text;
  }
}
