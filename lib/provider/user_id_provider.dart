import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserIdProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  String? _userId;
  String? get userId => _userId;

  void getCurrentUserId() {
    _userId = _supabase.auth.currentUser?.id;
    notifyListeners();
  }

  void clearUserId() {
    _userId = null;
    notifyListeners();
  }
}
