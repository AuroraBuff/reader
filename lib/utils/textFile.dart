import 'dart:io';

/// 本地文件读取（分段读取）
class TextFile {
  static Future<String> readTextFile(String path) async {
    return await File(path).readAsString();
  }
}
