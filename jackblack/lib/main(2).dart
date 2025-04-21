import 'package:flutter/material.dart';
import 'package:jackblack/modepage.dart';
import 'package:jackblack/titlepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "title",
      routes: {
        "title": (context) => const TitlePage(),
        "mode": (context) => const ModePage(),
      }
    );
  }
}