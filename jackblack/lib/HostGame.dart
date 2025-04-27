import 'package:flutter/material.dart';
import 'dart:math';
import 'p2p_manager.dart';


class HostGame extends StatefulWidget {
  const HostGame({super.key});


  @override
  _HostGameState createState() => _HostGameState();
}


class _HostGameState extends State<HostGame> {
  final P2PManager _p2pManager = P2PManager();
  final TextEditingController _pinController = TextEditingController();
  bool _isConnected = false;


  @override
  void initState() {
    super.initState();
    _initializeP2P();
  }


  Future<void> _initializeP2P() async {
    await _p2pManager.initialize();
  }


  String _generatePin() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString(); // Generate a 6-digit PIN
  }


  void _connectToServer() {
    final pin = _pinController.text;
    if (pin.length == 6) {
      // Logic to connect to the server using the PIN
      setState(() {
        _isConnected = true;
      });
      print('Connected with PIN: $pin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit PIN.')),
      );
    }
  }


  @override
  void dispose() {
    _p2pManager.dispose();
    _pinController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Game'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Host a Game',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Enter 6-digit PIN',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    final generatedPin = _generatePin();
                    _pinController.text = generatedPin;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _connectToServer,
              child: const Text('Connect'),
            ),
            const SizedBox(height: 16),
            if (_isConnected)
              const Text(
                'Connected to the server!',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
