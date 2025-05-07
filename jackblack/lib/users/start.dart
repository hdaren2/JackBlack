import 'package:flutter/material.dart';
import 'package:jackblack/users/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Supabase setup stuff
  await Supabase.initialize(
    url: "https://ahvxqvmprnrljncqiotz.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFodnhxdm1wcm5ybGpuY3Fpb3R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0MTc5MzYsImV4cCI6MjA2MDk5MzkzNn0.pZXJfYht7PsrqEiSagk0vgsN61bh0VpQkPoXtYxru6U",
  );

  runApp(const UsernamePage());
}


class UsernamePage extends StatelessWidget {
  const UsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // On app startup, go to auth process
      home: AuthGate(),
    );
  }
}