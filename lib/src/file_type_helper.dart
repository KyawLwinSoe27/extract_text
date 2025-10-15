// lib/src/file_type_helper.dart

enum FileType {
  pdf,
  docx,
  txt,
  image,
  unsupported,
}

class FileTypeHelper {
  static FileType getFileType(String path) {
    final ext = path.split('.').last.toLowerCase();

    if (ext == 'pdf') return FileType.pdf;
    if (ext == 'docx') return FileType.docx;
    if (ext == 'txt') return FileType.txt;
    if (['jpg', 'jpeg', 'png'].contains(ext)) return FileType.image;

    return FileType.unsupported;
  }
}
