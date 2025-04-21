import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class P2PManager {
  RTCPeerConnection? _peerConnection;
  final _localStreamController = StreamController<MediaStream>();
  final _remoteStreamController = StreamController<MediaStream>();

  Stream<MediaStream> get localStream => _localStreamController.stream;
  Stream<MediaStream> get remoteStream => _remoteStreamController.stream;

  // Configuration for STUN/TURN servers
  final _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ],
  };

  Future<void> initialize() async {
    _peerConnection = await createPeerConnection(_configuration);

    // Handle ICE candidates
    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      // Send the candidate to the remote peer
      // You'll need to implement your signaling mechanism here
    };

    // Handle remote stream
    _peerConnection?.onTrack = (RTCTrackEvent event) {
      _remoteStreamController.add(event.streams[0]);
    };
  }

  Future<RTCSessionDescription> createOffer() async {
    final offer = await _peerConnection?.createOffer();
    if (offer == null) throw Exception('Failed to create offer');
    await _peerConnection?.setLocalDescription(offer);
    return offer;
  }

  Future<void> setRemoteDescription(RTCSessionDescription description) async {
    await _peerConnection?.setRemoteDescription(description);
  }

  Future<void> addIceCandidate(RTCIceCandidate candidate) async {
    await _peerConnection?.addCandidate(candidate);
  }

  Future<void> createAnswer() async {
    final answer = await _peerConnection?.createAnswer();
    if (answer == null) throw Exception('Failed to create answer');
    await _peerConnection?.setLocalDescription(answer);
    // Send this answer to the remote peer through your signaling mechanism
  }

  Future<void> addLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      },
    };

    final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    stream.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, stream);
    });
    _localStreamController.add(stream);
  }

  void dispose() {
    _peerConnection?.close();
    _localStreamController.close();
    _remoteStreamController.close();
  }
}
