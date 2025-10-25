/// Simple plain-text file extractor.
///
/// This module provides a tiny utility class, [TxtExtractor], which reads
/// the entire contents of a plain text file from disk and returns it as a
/// [Future<String>]. It is intended for small-to-moderate sized text files
/// (config, logs, simple documents). For very large files consider streaming
/// or processing the file in chunks to avoid high memory usage.
///
/// Behavior and errors:
/// - Returns the full file content as a [String]. An empty file yields an
///   empty string.
/// - Uses `dart:io`'s default encoding when reading the file.
/// - May throw [FileSystemException] if the file does not exist or cannot be
///   read due to permissions or other I/O errors.
///
/// Example:
///
/// ```dart
/// final content = await TxtExtractor.extract('/path/to/file.txt');
/// print(content);
/// ```
library;

import 'dart:io';

class TxtExtractor {
  /// Reads the plain text file at [filePath] and returns its contents.
  ///
  /// Returns a [Future<String>] that completes with the file contents. The
  /// operation is asynchronous and will complete with an error if the
  /// underlying file cannot be accessed.
  static Future<String> extract(String filePath) async {
    return await File(filePath).readAsString();
  }
}
