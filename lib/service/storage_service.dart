import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StorageService {
  static final StorageService _instance = StorageService._init();
  StorageService._init();
  factory StorageService() => _instance;

  static final _supabase = Supabase.instance.client;

  Future<void> uploadFile(String name, Uint8List bytes) async {
    await _supabase.storage
        .from("files")
        .uploadBinary(name, bytes, fileOptions: FileOptions(upsert: true));
  }

  String getFileUrl(String name) {
    return _supabase.storage.from("files").getPublicUrl(name);
  }

  // returns PDF resource as bytes for showing
  Future<Uint8List?> getParsedFile(String name) async {
    final url = getFileUrl(name);
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return null;
    return res.bodyBytes;
  }
}
