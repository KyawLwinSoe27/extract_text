# extract_text

A Flutter package to extract text from **PDF**, **Word (.docx)**, **TXT**, and **image files (OCR)**.  
Supports Android and iOS for OCR and PDF extraction, and works with TXT and DOCX files on any Dart/Flutter platform.

---

## Features

- Extract text from PDF files using `read_pdf_text` (Android/iOS)
- Extract text from Word (.docx) files
- Extract text from plain TXT files
- Extract text from images (JPG, PNG) using ML Kit OCR
- Simple and unified API: `ExtractText.fromFile(filePath)`

---

## Installation

Add the package to your Flutter project in `pubspec.yaml`:

```yaml
dependencies:
  extract_text: ^0.0.1
 ```
Then run:

```bash
flutter pub get
```

## Usage

```dart
import 'package:extract_text/extract_text.dart';

void main() async {
  // Ensure Flutter bindings are initialized if using in main()
  // WidgetsFlutterBinding.ensureInitialized();

  final filePath = '/path/to/sample.pdf';

  try {
    final text = await ExtractText.fromFile(filePath);
    print('Extracted text:');
    print(text);
  } catch (e) {
    print('Error extracting text: $e');
  }
}
```

## Supported File Types

File Type	        Extension	        Notes
PDF	                .pdf	            Android/iOS only
Word	            .docx	            Works on all platforms
Text	            .txt	            Works on all platforms
Image	            .jpg/.jpeg/.png	    OCR using ML Kit (Android/iOS)

Example
You can create a small example/ folder in your package:

```dart
import 'package:flutter/material.dart';
import 'package:extract_text/extract_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Extract Text Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final text = await ExtractText.fromFile('/storage/emulated/0/Download/sample.pdf');
              print(text);
            },
            child: const Text('Extract PDF Text'),
          ),
        ),
      ),
    );
  }
}
```

# Changelog

## 0.0.1
- Initial release
- PDF, DOCX, TXT, and image (OCR) extraction

## Notes

For OCR and PDF extraction, Android and iOS platforms are required.

Make sure to call WidgetsFlutterBinding.ensureInitialized() before calling ExtractText.fromFile() in main() if your code runs before runApp().

For testing on desktop or Dart CLI, only TXT and DOCX files are supported.