// import 'package:shared_preferences/shared_preferences.dart';

// // ≈ Kotlin SharedPreferences in Dart
// class SharedPrefs {
//   static final SharedPrefs _instance = SharedPrefs._init();

//   SharedPrefs._init();

//   factory SharedPrefs() {
//     return _instance;
//   }

//   Future<void> addInt(String key, int value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(key, value); // await '.' setInt returns Future
//   }

//   Future<int> readInt(String key, int initial) async {
//     final prefs = await SharedPreferences.getInstance();
//     final res = prefs.getInt(key) ?? initial;
//     return res;
//   }
// }
