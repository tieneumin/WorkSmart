import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/secrets.dart';
import 'package:provider/provider.dart';
import 'package:worksmart/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/nav/nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required before any async init in main()
  await Supabase.initialize(url: supabaseProjectUrl, anonKey: supabaseAnonKey);

  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "WorkSmart",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade700,
          primary: Colors.blue.shade700,
        ),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(routes: Nav.routes, initialLocation: Nav.initial),
    );
  }
}
