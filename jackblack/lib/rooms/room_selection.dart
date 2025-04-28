import 'package:flutter/material.dart';
import 'package:jackblack/rooms/room.dart';
import 'package:jackblack/rooms/multiplayer_game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomSelectionPage extends StatefulWidget {
  const RoomSelectionPage({super.key});

  @override
  State<RoomSelectionPage> createState() => _RoomSelectionPageState();
}

class _RoomSelectionPageState extends State<RoomSelectionPage> {
  final RoomService _roomService = RoomService();
  List<Room> _availableRooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await _roomService.getAvailableRooms();
      setState(() {
        _availableRooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading rooms: $e')));
    }
  }

  Future<void> _createRoom() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final room = await _roomService.createRoom(user.id);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiplayerGamePage(room: room),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating room: $e')));
    }
  }

  Future<void> _joinRoom(Room room) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      final updatedRoom = await _roomService.joinRoom(room.id, user.id);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiplayerGamePage(room: updatedRoom),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error joining room: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 126, 75, 1),
      appBar: AppBar(
        title: Text('Multiplayer Rooms'),
        backgroundColor: Color.fromRGBO(33, 126, 75, 1),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadRooms,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    ElevatedButton(
                      onPressed: _createRoom,
                      child: Text('Create New Room'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Available Rooms',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_availableRooms.isEmpty)
                      Center(
                        child: Text(
                          'No rooms available. Create one!',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    else
                      ..._availableRooms.map(
                        (room) => Card(
                          child: ListTile(
                            title: Text('Room ${room.id.substring(0, 8)}'),
                            subtitle: Text(
                              '${room.playerIds.length}/${room.maxPlayers} players',
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _joinRoom(room),
                              child: Text('Join'),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
