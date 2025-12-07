import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/core/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wnzewejxrhjnjvyrshzp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InduemV3ZWp4cmhqbmp2eXJzaHpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAxMTQ0NjgsImV4cCI6MjA3NTY5MDQ2OH0.AvAyLKKqygD6tNmpR7a6eyayFoMdAl6q5EKTB9UkCMA',
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(routerConfig: router,
      title: 'WinePool App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),);
  }
}