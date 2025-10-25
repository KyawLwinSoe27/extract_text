/// Utilities for determining the file type from a filesystem path.
///
/// This helper provides a lightweight `FileType` enum and a single
/// convenience method, `FileTypeHelper.getFileType`, which inspects a file
/// path's extension and returns a corresponding [FileType]. It is used by
/// the package to choose the correct text extractor for a given file.
///
/// Notes and edge cases:
/// - The detection is based solely on the path string's extension (the
///   substring after the last `.`). It does not inspect file headers or
///   MIME types.
/// - Extensions are matched case-insensitively (for example `.PDF` and
///   `.pdf` are treated the same).
/// - If the path has no `.` (no extension) the entire path is treated as
///   the extension by the current implementation — callers should ensure
///   they pass a proper filename or modify this helper if stricter checks
///   are required.
///
/// Example:
///
/// ```dart
/// final type = FileTypeHelper.getFileType('documents/report.pdf');
/// // type == FileType.pdf
/// ```
library;

/// Supported file type categories returned by [FileTypeHelper].
enum FileType { pdf, docx, txt, image, unsupported }

/// Simple helper that maps a file path to a [FileType].
///
/// The method looks at the final extension token after the last `.` in the
/// provided [path] and returns the corresponding enum value:
/// - `pdf` -> [FileType.pdf]
/// - `docx` -> [FileType.docx]
/// - `txt` -> [FileType.txt]
/// - `jpg`, `jpeg`, `png` -> [FileType.image]
/// - anything else -> [FileType.unsupported]
class FileTypeHelper {
  /// Returns the [FileType] for the given filesystem [path].
  ///
  /// This function performs a lightweight, extension-based classification.
  /// It is fast and suitable for routing a file to the appropriate
  /// extractor, but it does not verify the file's contents. If you need to
  /// validate file contents, perform additional checks after classification.
  static FileType getFileType(String path) {
    final ext = path.split('.').last.toLowerCase();

    if (ext == 'pdf') return FileType.pdf;
    if (ext == 'docx') return FileType.docx;
    if (ext == 'txt') return FileType.txt;
    if (['jpg', 'jpeg', 'png'].contains(ext)) return FileType.image;

    return FileType.unsupported;
  }
}
