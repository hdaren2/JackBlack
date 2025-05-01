import 'package:supabase_flutter/supabase_flutter.dart';

class Room {
  final String id;
  final String hostId;
  final int maxPlayers;
  final bool isGameStarted;
  final DateTime createdAt;
  final String name;

  Room({
    required this.id,
    required this.hostId,
    required this.maxPlayers,
    required this.isGameStarted,
    required this.createdAt,
    required this.name,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      maxPlayers: json['max_players'] as int,
      isGameStarted: json['is_game_started'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'host_id': hostId,
      'max_players': maxPlayers,
      'is_game_started': isGameStarted,
      'created_at': createdAt.toIso8601String(),
      'name': name,
    };
  }
}

class RoomService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Map<String, RealtimeChannel> _presenceChannels = {};

  Future<Room> createRoom(String hostId, String roomName) async {
    final response =
        await _supabase
            .from('rooms')
            .insert({
              'host_id': hostId,
              'max_players': 4,
              'is_game_started': false,
              'created_at': DateTime.now().toIso8601String(),
              'name': roomName,
            })
            .select()
            .single();

    final room = Room.fromJson(response);
    await _trackPresence(room.id, hostId);
    return room;
  }

  Future<Room> joinRoom(String roomId, String playerId) async {
    final room = await getRoom(roomId);
    if (room.isGameStarted) {
      throw Exception('Game has already started');
    }

    // Get current presence state
    final presenceState = _presenceChannels[roomId]?.presenceState();
    if (presenceState != null && presenceState.length >= room.maxPlayers) {
      throw Exception('Room is full');
    }

    await _trackPresence(roomId, playerId);
    return room;
  }

  Future<void> leaveRoom(String roomId, String playerId) async {
    await _untrackPresence(roomId, playerId);
  }

  Future<void> _trackPresence(String roomId, String playerId) async {
    if (!_presenceChannels.containsKey(roomId)) {
      final channel = _supabase.channel('room:$roomId');
      _presenceChannels[roomId] = channel;

      channel.onPresenceSync((_) {
        // Presence state is automatically updated in the channel
      }).subscribe();
    }

    await _presenceChannels[roomId]?.track({
      'user_id': playerId,
      'online_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _untrackPresence(String roomId, String playerId) async {
    final channel = _presenceChannels[roomId];
    if (channel != null) {
      await channel.untrack();
      if (channel.presenceState().isEmpty) {
        await channel.unsubscribe();
        _presenceChannels.remove(roomId);
      }
    }
  }

  Future<Room> getRoom(String roomId) async {
    final response =
        await _supabase.from('rooms').select().eq('id', roomId).single();
    return Room.fromJson(response);
  }

  Future<List<Room>> getAvailableRooms() async {
    final response = await _supabase
        .from('rooms')
        .select()
        .eq('is_game_started', false)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Room.fromJson(json)).toList();
  }

  Future<void> startGame(String roomId) async {
    await _supabase
        .from('rooms')
        .update({'is_game_started': true})
        .eq('id', roomId);
  }

  Stream<Room> subscribeToRoom(String roomId) {
    return _supabase
        .from('rooms')
        .stream(primaryKey: ['id'])
        .eq('id', roomId)
        .map((data) => Room.fromJson(data.first));
  }

  // Get current presence state for a room
  List<SinglePresenceState>? getRoomPresence(String roomId) {
    return _presenceChannels[roomId]?.presenceState();
  }

  // Get number of active players in a room
  int getActivePlayerCount(String roomId) {
    final presenceState = getRoomPresence(roomId);
    return presenceState?.length ?? 0;
  }
}
