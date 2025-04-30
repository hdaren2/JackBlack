import 'package:supabase_flutter/supabase_flutter.dart';

class Room {
  final String id;
  final String hostId;
  final List<String> playerIds;
  final int maxPlayers;
  final bool isGameStarted;
  final DateTime createdAt;
  final String name;

  Room({
    required this.id,
    required this.hostId,
    required this.playerIds,
    required this.maxPlayers,
    required this.isGameStarted,
    required this.createdAt,
    required this.name,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      playerIds: List<String>.from(json['player_ids']),
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
      'player_ids': playerIds,
      'max_players': maxPlayers,
      'is_game_started': isGameStarted,
      'created_at': createdAt.toIso8601String(),
      'name': name,
    };
  }
}

class RoomService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Room> createRoom(String hostId, String roomName) async {
    final response =
        await _supabase
            .from('rooms')
            .insert({
              'host_id': hostId,
              'player_ids': [hostId],
              'max_players': 4,
              'is_game_started': false,
              'created_at': DateTime.now().toIso8601String(),
              'name': roomName,
            })
            .select()
            .single();

    return Room.fromJson(response);
  }

  Future<Room> joinRoom(String roomId, String playerId) async {
    final room = await getRoom(roomId);
    if (room.playerIds.length >= room.maxPlayers) {
      throw Exception('Room is full');
    }
    if (room.isGameStarted) {
      throw Exception('Game has already started');
    }

    final updatedPlayerIds = [...room.playerIds, playerId];
    final response =
        await _supabase
            .from('rooms')
            .update({'player_ids': updatedPlayerIds})
            .eq('id', roomId)
            .select()
            .single();

    return Room.fromJson(response);
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
}
