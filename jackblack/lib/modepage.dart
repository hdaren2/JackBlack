import 'package:flutter/material.dart';
import 'package:jackblack/game.dart';
import 'package:jackblack/titlepage.dart';
import 'package:jackblack/widgets/custom_button.dart';
import 'package:jackblack/rooms/room_selection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModePage extends StatefulWidget {
  const ModePage({super.key});

  @override
  State<ModePage> createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  bool _isInitialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeSupabase();
  }

  Future<void> _initializeSupabase() async {
    try {
      await Supabase.initialize(
        url: "https://ahvxqvmprnrljncqiotz.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFodnhxdm1wcm5ybGpuY3Fpb3R6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0MTc5MzYsImV4cCI6MjA2MDk5MzkzNn0.pZXJfYht7PsrqEiSagk0vgsN61bh0VpQkPoXtYxru6U",
      );
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _handleRoomAction(BuildContext context, bool isHosting) {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supabase is not initialized yet')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomSelectionPage(isHosting: isHosting),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Error Initializing",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'Minecraft',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Minecraft',
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(text: "Retry", onPressed: _initializeSupabase),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color.fromRGBO(33, 126, 75, 1),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select\nGame Mode",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Minecraft',
                shadows: [
                  Shadow(
                    offset: Offset(5, 5),
                    blurRadius: 0,
                    color: Color.fromRGBO(63, 63, 63, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: "Play Against Dealer",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
              },
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Host Game",
              width: 302,
              onPressed: () => _handleRoomAction(context, true),
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Join Game",
              width: 302,
              onPressed: () => _handleRoomAction(context, false),
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Back",
              width: 302,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TitlePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
