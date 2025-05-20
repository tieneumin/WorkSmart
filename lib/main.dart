import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worksmart/nav/nav.dart';
import 'package:go_router/go_router.dart';
import 'package:worksmart/secrets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // required before any platform-specific/async initialization in main()

  await Supabase.initialize(url: supabaseProjectUrl, anonKey: supabaseAnonKey);
  runApp(
    MyApp(),
    // ChangeNotifierProvider(
    //   create: (context) => CounterProvider(),
    //   child: const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WorkSmart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(routes: Nav.routes, initialLocation: Nav.initial),
    );
  }
}
