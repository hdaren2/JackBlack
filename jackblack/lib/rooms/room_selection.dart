import 'package:flutter/material.dart';
import 'package:jackblack/rooms/room.dart';
import 'package:jackblack/users/auth_service.dart';
import 'package:jackblack/widgets/custom_button.dart';
import 'package:jackblack/rooms/multiplayer_game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomSelectionPage extends StatefulWidget {
  final bool isHosting;

  const RoomSelectionPage({super.key, required this.isHosting});

  @override
  State<RoomSelectionPage> createState() => _RoomSelectionPageState();
}

class _RoomSelectionPageState extends State<RoomSelectionPage> {
  final RoomService _roomService = RoomService();
  List<Room> _rooms = [];
  bool _isLoading = true;
  final TextEditingController _roomNameController = TextEditingController();
  final AuthService _authService = AuthService();
  final Map<String, int> _roomPlayerCounts = {};

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  Future<void> _loadRooms() async {
    setState(() => _isLoading = true);
    try {
      final rooms = await _roomService.getAvailableRooms();
      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });

      // Update player counts for each room
      for (final room in rooms) {
        final count = _roomService.getActivePlayerCount(room.id);
        setState(() {
          _roomPlayerCounts[room.id] = count;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading rooms: $e')));
    }
  }

  Future<void> _createRoom() async {
    if (_roomNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a room name')));
      return;
    }

    try {
      final room = await _roomService.createRoom(
        _authService.getUUID().toString(),
        _roomNameController.text,
      );
      _roomNameController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => MultiplayerGamePage(
                room: room,
                user: Supabase.instance.client.auth.currentUser!,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating room: $e')));
    }
  }

  Future<void> _joinRoom(String roomId) async {
    try {
      final room = await _roomService.joinRoom(
        roomId,
        _authService.getUUID().toString(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => MultiplayerGamePage(
                room: room,
                user: Supabase.instance.client.auth.currentUser!,
              ),
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
      backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      appBar: AppBar(
        title: Text(widget.isHosting ? 'Host Game' : 'Join Game', style: TextStyle(fontFamily: 'Minecraft', fontSize: 24, color: Colors.white, shadows: [Shadow(offset: Offset(2, 2), blurRadius: 0, color: Color.fromRGBO(63, 63, 63, 1))])),
        backgroundColor: const Color.fromRGBO(33, 126, 75, 1),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadRooms,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (widget.isHosting) ...[
                      TextField(
                        cursorColor: Color.fromRGBO(66, 66, 66, 1),
                        style: TextStyle(
                          fontFamily: 'Minecraft'
                        ),
                        controller: _roomNameController,
                        decoration: const InputDecoration(
                          labelText: 'Room Name',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(66, 66, 66, 1))
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(66, 66, 66, 1))
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(66, 66, 66, 1))
                          ),
                          labelStyle: TextStyle(color: Color.fromRGBO(66, 66, 66, 1), fontFamily: 'Minecraft')
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: "Create New Room",
                        onPressed: _createRoom,
                      ),
                      const SizedBox(height: 20),
                    ],
                    const Text(
                      'Available Rooms',
                      style: TextStyle(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Minecraft',
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 0,
                            color: Color.fromRGBO(63, 63, 63, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._rooms.map(
                      (room) => Card(
                        child: ListTile(
                          title: Text(room.name),
                          subtitle: Text(
                            '${_roomPlayerCounts[room.id] ?? 0}/${room.maxPlayers} players',
                          ),
                          trailing:
                              !widget.isHosting
                                  ? ElevatedButton(
                                    onPressed: () => _joinRoom(room.id),
                                    child: const Text('Join'),
                                  )
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
