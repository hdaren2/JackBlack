import 'package:flutter/material.dart';
import 'package:jackblack/modepage.dart';
import 'package:jackblack/titlepage.dart';
import 'package:jackblack/users/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:jackblack/users/start.dart";


void main() async {
  // Supabase setup stuff
  await Supabase.initialize(
    url: "https://ahvxqvmprnrljncqiotz.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFodnhxdm1wcm5ybGpuY3Fpb3R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0MTc5MzYsImV4cCI6MjA2MDk5MzkzNn0.pZXJfYht7PsrqEiSagk0vgsN61bh0VpQkPoXtYxru6U",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Minecraft',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Minecraft'),
          bodyMedium: TextStyle(fontFamily: 'Minecraft'),
          titleLarge: TextStyle(fontFamily: 'Minecraft'),
          titleMedium: TextStyle(fontFamily: 'Minecraft'),
          titleSmall: TextStyle(fontFamily: 'Minecraft'),
        ),
      ),
      initialRoute: "auth",
      routes: {
        "auth": (context) => const UsernamePage(),
        "title": (context) => const TitlePage(),
        "mode": (context) => const ModePage(),
      },
    );
  }
}
