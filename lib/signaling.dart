import 'dart:convert';
import 'dart:io';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Signaling {
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;
  late Function(MediaStream stream) onAddRemoteStream;

  late WebSocket _socket;

  void joinRoom() async {
    _socket = await WebSocket.connect('ws://localhost:3000');
    _socket.listen((data) async {
      var message = jsonDecode(data);
      switch (message['type']) {
        case 'offer':
          await _setRemoteDescription(message['sdp']);
          await _createAnswer();
          break;
        case 'answer':
          await _setRemoteDescription(message['sdp']);
          break;
        case 'candidate':
          await _addCandidate(message['candidate']);
          break;
      }
    });
  }

  Future<void> openUserMedia(RTCVideoRenderer localRenderer) async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });
    localRenderer.srcObject = _localStream;
  }



  Future<void> _createAnswer() async {
    var answer = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(answer);
    _socket.add(jsonEncode({
      'type': 'answer',
      'sdp': answer.sdp,
    }));
  }

  Future<void> _setRemoteDescription(String sdp) async {
    var description = RTCSessionDescription(sdp, 'answer');
    await _peerConnection.setRemoteDescription(description);
  }

  Future<void> _addCandidate(String candidate) async {
    var iceCandidate = RTCIceCandidate(candidate, '', 0);
    await _peerConnection.addCandidate(iceCandidate);
  }

  static void sendIceCandidate(RTCIceCandidate candidate) {}
}
