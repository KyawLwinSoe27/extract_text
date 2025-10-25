/// OCR extractor using the `tesseract_ocr` plugin.
///
/// This module exposes [TesseractOCTExtractor], a small helper that runs
/// OCR against an image file and returns the recognized text.
///
/// Key points:
/// - Uses two OCR engine configurations: the native Tesseract engine for
///   non-iOS platforms and Apple's Vision engine on iOS (via the plugin's
///   `OCRConfig` and engine selection).
/// - The default `supportedLanguages` list includes `mya` (Burmese),
///   `eng` (English), and `tha` (Thai). Languages are joined with `+` when
///   passed to the underlying engine (e.g. `eng+mya`). You may modify
///   `TesseractOCTExtractor.supportedLanguages` before calling
///   [performOcr].
/// - The plugin requires corresponding trained data files to be available
///   on the device (for Tesseract) or appropriate language support on iOS.
///   Ensure your app bundles or downloads the required `.traineddata`
///   assets (for example, via `assets/tessdata/`) and configures the
///   plugin according to its documentation.
///
/// Return value and error handling:
/// - On success the method completes with a `String` containing the
///   recognized text (may be empty if nothing was recognized).
/// - On failure this implementation returns a string starting with
///   `Error performing OCR:` followed by the exception message rather than
///   throwing. Callers should detect this convention if they need to
///   differentiate error cases from legitimate OCR results.
///
/// Example:
///
/// ```dart
/// final result = await TesseractOCTExtractor.performOcr('path/to/image.png');
/// if (result.startsWith('Error performing OCR:')) {
///   // handle error
/// } else {
///   print('OCR text: $result');
/// }
/// ```
library;

import 'dart:io';

import 'package:tesseract_ocr/ocr_engine_config.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class TesseractOCTExtractor {
  /// Languages requested for OCR. The list items will be joined with `+`
  /// when passed to the OCR engine (for example: `eng+mya`).
  ///
  /// Modify this list before calling [performOcr] if you need different
  /// or additional languages.
  static List<String> supportedLanguages = ['mya', 'eng', 'tha'];

  /// Performs OCR on the image at [imagePath] and returns the recognized
  /// text as a [Future<String>].
  ///
  /// The method selects the OCR engine based on the current platform:
  /// - iOS: uses the Vision engine via `OCRConfig(engine: OCREngine.vision)`.
  /// - Other platforms: uses the Tesseract engine via
  ///   `OCRConfig(engine: OCREngine.tesseract)`.
  ///
  /// Notes:
  /// - The returned text may contain line breaks and spacing as produced
  ///   by the underlying OCR engine. OCR accuracy depends on image quality
  ///   and the availability of appropriate trained data.
  /// - On error this implementation returns a string that begins with
  ///   `Error performing OCR:` followed by the exception message. This is
  ///   done to keep the API simple for callers that directly display the
  ///   result. If you prefer thrown exceptions, wrap the call and rethrow
  ///   or modify this method to propagate errors.
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
