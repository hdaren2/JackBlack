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
