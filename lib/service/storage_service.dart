import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StorageService {
  static final StorageService _instance = StorageService._init();
  StorageService._init();
  factory StorageService() {
    return _instance;
  }

  static final supabase = Supabase.instance.client;

  Future<void> uploadFile(String name, Uint8List bytes) async {
    final resp = await supabase.storage
        .from("files")
        .uploadBinary(name, bytes, fileOptions: FileOptions(upsert: true));
    debugPrint("File uploaded $resp");
  }

  Future<Uint8List?> getFile(String name) async {
    final url = supabase.storage.from("files").getPublicUrl(name);
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      return null;
    }
    return resp.bodyBytes;
  }
}
