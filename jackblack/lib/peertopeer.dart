import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ahvxqvmprnrljncqiotz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFodnhxdm1wcm5ybGpuY3Fpb3R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0MTc5MzYsImV4cCI6MjA2MDk5MzkzNn0.pZXJfYht7PsrqEiSagk0vgsN61bh0VpQkPoXtYxru6U',
  );
  runApp(MyApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

//Hunter was here
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peer to Peer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Get Text from Text Field
  final textController = TextEditingController();

  void addNote() {
    showDialog(
      context: context,
      builder:
          (context) =>
              AlertDialog(content: TextField(controller: textController), actions: [
                //save button.
              ],),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Peer To Peer Test"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [FloatingActionButton(onPressed: addNote)],
      ),
    );
  }
}
