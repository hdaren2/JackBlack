import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jackblack/rooms/room.dart';
import 'package:jackblack/player.dart';
import 'package:jackblack/card.dart';
import 'package:jackblack/shoe.dart';
import 'package:jackblack/hand.dart';

class MultiplayerGamePage extends StatefulWidget {
  final Room room;
  final User user;

  const MultiplayerGamePage({Key? key, required this.room, required this.user})
    : super(key: key);

  @override
  State<MultiplayerGamePage> createState() => _MultiplayerGamePageState();
}

class _MultiplayerGamePageState extends State<MultiplayerGamePage> {
  final RoomService _roomService = RoomService();
  late StreamSubscription<Room> _roomSubscription;
  late StreamSubscription<Room> _presenceSubscription;
  bool isGameStarted = false;
  String _gameMessage = "Waiting for players...";
  List<SinglePresenceState>? _presenceState;
  List<Player> _players = [];
  final DealerHand dealer = DealerHand();
  int currentPlayerIndex = 0;
  bool isDealerTurn = false;
  final Shoe shoe = Shoe(6);

  @override
  void initState() {
    super.initState();
    _subscribeToRoom();
    _subscribeToPresence();
  }

  void _subscribeToPresence() {
    _presenceSubscription = _roomService.subscribeToRoom(widget.room.id).listen(
      (room) {
        final presenceState = _roomService.getRoomPresence(widget.room.id);
        if (presenceState != null) {
          setState(() {
            _presenceState = presenceState;
            _updatePlayersFromPresence();
          });
        }
      },
    );
  }

  void _subscribeToRoom() {
    _roomSubscription = _roomService.subscribeToRoom(widget.room.id).listen((
      room,
    ) {
      if (room.isGameStarted && !isGameStarted) {
        setState(() {
          isGameStarted = true;
          _gameMessage = "Game started!";
        });
      }
    });
  }

  void _updatePlayersFromPresence() {
    if (_presenceState != null) {
      setState(() {
        _players =
            _presenceState!.map((state) {
              final data = state.presences.first.payload;
              return Player(name: data['user_id'] as String, funds: 1000.0);
            }).toList();
      });
    }
  }

  void _startGame() {
    if (_players.isEmpty) return;

    setState(() {
      for (final player in _players) {
        if (player.hands.isEmpty) {
          player.addEmptyHand();
          player.hands[0].bet = 100.0;
        }
      }
      dealer.clear();
      _dealInitialCards();
      _gameMessage = "${_players[0].name}'s turn";
    });
  }

  void _dealInitialCards() {
    for (final player in _players) {
      player.hands[0].add(shoe.deal());
      player.hands[0].add(shoe.deal());
    }
    dealer.add(shoe.deal());
    dealer.add(shoe.deal());
  }

  void _hit() {
    setState(() {
      final currentPlayer = _players[currentPlayerIndex];
      currentPlayer.hit(currentPlayer.hands[0], shoe);
      if (currentPlayer.hands[0].sum > 21) {
        _nextPlayer();
      }
    });
  }

  void _stand() {
    _nextPlayer();
  }

  void _nextPlayer() {
    setState(() {
      currentPlayerIndex++;
      if (currentPlayerIndex >= _players.length) {
        isDealerTurn = true;
        _dealerPlay();
      } else {
        _gameMessage = "${_players[currentPlayerIndex].name}'s turn";
      }
    });
  }

  void _dealerPlay() {
    setState(() {
      while (dealer.sum < 17) {
        dealer.add(shoe.deal());
      }
      _determineWinners();
    });
  }

  void _determineWinners() {
    setState(() {
      final dealerScore = dealer.sum;
      for (final player in _players) {
        final playerScore = player.hands[0].sum;
        if (playerScore > 21) {
          player.funds -= player.hands[0].bet;
        } else if (dealerScore > 21 || playerScore > dealerScore) {
          player.funds += player.hands[0].bet;
        } else if (playerScore < dealerScore) {
          player.funds -= player.hands[0].bet;
        }
      }
      _gameMessage = "Round over!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        actions: [
          if (widget.room.hostId == widget.user.id && !isGameStarted)
            TextButton(
              onPressed: () {
                _roomService.startGame(widget.room.id);
                _startGame();
              },
              child: const Text('Start Game'),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(_gameMessage),
          ),
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      const Text('Dealer'),
                      Wrap(
                        spacing: 8,
                        children:
                            dealer.hand
                                .map((card) => PlayingCardWidget(card: card))
                                .toList(),
                      ),
                      const SizedBox(height: 20),
                      ..._players.asMap().entries.map((entry) {
                        final index = entry.key;
                        final player = entry.value;
                        return Column(
                          children: [
                            Text(player.name),
                            Wrap(
                              spacing: 8,
                              children:
                                  player.hands[0].hand
                                      .map(
                                        (card) => PlayingCardWidget(card: card),
                                      )
                                      .toList(),
                            ),
                            if (isGameStarted && currentPlayerIndex == index)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: _hit,
                                    child: const Text('Hit'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: _stand,
                                    child: const Text('Stand'),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (mounted) {
      _roomService.leaveRoom(widget.room.id, widget.user.id);
    }
    _presenceSubscription.cancel();
    _roomSubscription.cancel();
    super.dispose();
  }
}
