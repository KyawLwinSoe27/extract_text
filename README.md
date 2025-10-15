# extract_text

A Flutter package to extract text from PDF, Word (.docx), TXT, and image files (OCR).

## Installation

Add to `pubspec.yaml`:

```yaml
dependencies:
  extract_text: ^0.0.1
```
import 'package:extract_text/extract_text.dart';

final text = await ExtractText.fromFile('/path/to/file.pdf');
print(text);


---

### c) Add `CHANGELOG.md`

- Document all versions and changes:

```markdown
# Changelog

## 0.0.1
- Initial release with PDF, DOCX, TXT, and OCR extraction
```