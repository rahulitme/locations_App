// // import 'package:flutter/material.dart';
// // import 'package:flutter_webrtc/flutter_webrtc.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // class CallScreen extends StatefulWidget {
// //   const CallScreen({super.key});

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _CallScreenState createState() => _CallScreenState();
// // }

// // class _CallScreenState extends State<CallScreen> {
// //   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
// //   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
// //   RTCPeerConnection? _peerConnection;
// //   MediaStream? _localStream;
// //   final bool _isCaller = true;

// //   bool? get kDebugMode => null; // Track if this peer is the caller

// //   @override
// //   void initState() {
// //     super.initState();
// //     initRenderers();
// //     _createPeerConnection();
// //   }

// //   @override
// //   void dispose() {
// //     _localRenderer.dispose();
// //     _remoteRenderer.dispose();
// //     super.dispose();
// //   }

// //   initRenderers() async {
// //     await _localRenderer.initialize();
// //     await _remoteRenderer.initialize();
// //   }

// //   Future<void> _createPeerConnection() async {
// //     final config = {
// //       'iceServers': [
// //         {'urls': 'stun:stun.l.google.com:19302'}, // Public Google STUN server
// //       ],
// //     };
// //     final constraints = {
// //       'mandatory': {},
// //       'optional': [{'DtlsSrtpKeyAgreement': true}]
// //     };
// //     _peerConnection = await createPeerConnection(config, constraints);

// //     _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
// //      {
// //       }
// //       // Send the ICE candidate to the remote peer via signaling server
// //     };

// //     _peerConnection!.onAddStream = (MediaStream stream) {
// //       setState(() {
// //         _remoteRenderer.srcObject = stream;
// //       });
// //     };

// //     // Get the local media stream (camera and microphone)
// //     _localStream = await navigator.mediaDevices.getUserMedia({
// //       'video': true,
// //       'audio': true,
// //     });

// //     setState(() {
// //       _localRenderer.srcObject = _localStream;
// //     });

// //     _peerConnection!.addStream(_localStream!);

// //     // Caller creates offer
// //     if (_isCaller) {
// //       _createOffer();
// //     } else {
// //       // Waiting for the other peer to send an offer
// //     }
// //   }

// //   Future<void> _createOffer() async {
// //     RTCSessionDescription offer = await _peerConnection!.createOffer({
// //       'offerToReceiveAudio': 1,
// //       'offerToReceiveVideo': 1,
// //     });
// //     await _peerConnection!.setLocalDescription(offer);

// //     // Send the offer to the remote peer via signaling server
// //     // Signaling server logic to send offer should go here
// //   }

// //   Future<void> _createAnswer() async {
// //     RTCSessionDescription answer = await _peerConnection!.createAnswer({
// //       'offerToReceiveAudio': 1,
// //       'offerToReceiveVideo': 1,
// //     });
// //     await _peerConnection!.setLocalDescription(answer);

// //     // Send the answer to the remote peer via signaling server
// //     // Signaling server logic to send answer should go here
// //   }

// //   Future<void> _setRemoteDescription(RTCSessionDescription description) async {
// //     await _peerConnection!.setRemoteDescription(description);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('WebRTC Peer-to-Peer Call')),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: RTCVideoView(_localRenderer),
// //           ),
// //           Expanded(
// //             child: RTCVideoView(_remoteRenderer),
// //           ),
// //           ElevatedButton(
// //             onPressed: () async {
// //               // Simulate signaling to receive an offer
// //               if (!_isCaller) {
// //                 final remoteOffer = await _getRemoteOffer();
// //                 await _setRemoteDescription(RTCSessionDescription(
// //                     remoteOffer['sdp'], remoteOffer['type']));
// //                 await _createAnswer();
// //               }
// //             },
// //             child: Text(_isCaller ? "Waiting for Answer" : "Receive Offer"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<Map<String, dynamic>> _getRemoteOffer() async {
// //     // Replace this with actual signaling server logic
// //     // Here we simulate getting the offer via HTTP or WebSocket
// //     var response = await http.get(Uri.parse('https://example.com/offer'));
// //     return jsonDecode(response.body);
// //   }
// // }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_webrtc/flutter_webrtc.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // class CallScreen extends StatefulWidget {
// //   final bool isCaller;
// //   final String roomId;

// //   const CallScreen({super.key, required this.isCaller, required this.roomId});

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _CallScreenState createState() => _CallScreenState();
// // }

// // class _CallScreenState extends State<CallScreen> {
// //   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
// //   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
// //   RTCPeerConnection? _peerConnection;
// //   MediaStream? _localStream;

// //   @override
// //   void initState() {
// //     super.initState();
// //     initRenderers();
// //     _createPeerConnection().then((_) {
// //       if (widget.isCaller) {
// //         _createOffer();
// //       } else {
// //         _joinCall();
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _localRenderer.dispose();
// //     _remoteRenderer.dispose();
// //     _peerConnection?.dispose();
// //     _localStream?.dispose();
// //     super.dispose();
// //   }

// //   Future<void> initRenderers() async {
// //     await _localRenderer.initialize();
// //     await _remoteRenderer.initialize();
// //   }

// //   Future<void> _createPeerConnection() async {
// //     final config = {
// //       'iceServers': [
// //         {'urls': 'stun:stun.l.google.com:19302'},
// //       ],
// //     };
// //     _peerConnection = await createPeerConnection(config, {});

// //     _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
// //       _sendIceCandidate(candidate);
// //     };

// //     _peerConnection!.onTrack = (RTCTrackEvent event) {
// //       if (event.track.kind == 'video') {
// //         setState(() {
// //           _remoteRenderer.srcObject = event.streams[0];
// //         });
// //       }
// //     };

// //     _localStream = await navigator.mediaDevices.getUserMedia({
// //       'audio': true,
// //       'video': true,
// //     });

// //     _localStream!.getTracks().forEach((track) {
// //       _peerConnection!.addTrack(track, _localStream!);
// //     });

// //     setState(() {
// //       _localRenderer.srcObject = _localStream;
// //     });
// //   }

// //   Future<void> _createOffer() async {
// //     RTCSessionDescription offer = await _peerConnection!.createOffer();
// //     await _peerConnection!.setLocalDescription(offer);
// //     _sendOffer(offer);
// //   }

// //   Future<void> _joinCall() async {
// //     RTCSessionDescription offer = await _getRemoteOffer();
// //     await _peerConnection!.setRemoteDescription(offer);
// //     RTCSessionDescription answer = await _peerConnection!.createAnswer();
// //     await _peerConnection!.setLocalDescription(answer);
// //     _sendAnswer(answer);
// //   }

// //   Future<void> _sendOffer(RTCSessionDescription offer) async {
// //     await http.post(
// //       Uri.parse('https://your-signaling-server.com/offer'),
// //       body: jsonEncode({
// //         'roomId': widget.roomId,
// //         'offer': offer.toMap(),
// //       }),
// //     );
// //   }

// //   Future<void> _sendAnswer(RTCSessionDescription answer) async {
// //     await http.post(
// //       Uri.parse('https://your-signaling-server.com/answer'),
// //       body: jsonEncode({
// //         'roomId': widget.roomId,
// //         'answer': answer.toMap(),
// //       }),
// //     );
// //   }

// //   Future<void> _sendIceCandidate(RTCIceCandidate candidate) async {
// //     await http.post(
// //       Uri.parse('https://your-signaling-server.com/ice-candidate'),
// //       body: jsonEncode({
// //         'roomId': widget.roomId,
// //         'candidate': candidate.toMap(),
// //       }),
// //     );
// //   }

// //   Future<RTCSessionDescription> _getRemoteOffer() async {
// //     final response = await http.get(
// //       Uri.parse('https://your-signaling-server.com/offer?roomId=${widget.roomId}'),
// //     );
// //     final offerMap = jsonDecode(response.body);
// //     return RTCSessionDescription(offerMap['sdp'], offerMap['type']);
// //   }

// //   void _toggleMic() {
// //     if (_localStream != null) {
// //       bool enabled = _localStream!.getAudioTracks()[0].enabled;
// //       _localStream!.getAudioTracks()[0].enabled = !enabled;
// //       setState(() {});
// //     }
// //   }

// //   void _toggleCamera() {
// //     if (_localStream != null) {
// //       bool enabled = _localStream!.getVideoTracks()[0].enabled;
// //       _localStream!.getVideoTracks()[0].enabled = !enabled;
// //       setState(() {});
// //     }
// //   }

// //   void _endCall() {
// //     _peerConnection?.close();
// //     _localStream?.dispose();
// //     setState(() {});
// //     Navigator.pop(context);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('WebRTC Peer-to-Peer Call')),
// //       body: OrientationBuilder(
// //         builder: (context, orientation) {
// //           return Stack(
// //             children: [
// //               Positioned.fill(
// //                 child: RTCVideoView(_remoteRenderer),
// //               ),
// //               Positioned(
// //                 left: 20,
// //                 top: 20,
// //                 width: 120,
// //                 height: 160,
// //                 child: Container(
// //                   decoration: BoxDecoration(border: Border.all(color: Colors.white)),
// //                   child: RTCVideoView(_localRenderer),
// //                 ),
// //               ),
// //               Positioned(
// //                 bottom: 20,
// //                 left: 0,
// //                 right: 0,
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: [
// //                     IconButton(
// //                       icon: Icon(_localStream?.getAudioTracks()[0].enabled ?? false
// //                           ? Icons.mic
// //                           : Icons.mic_off),
// //                       onPressed: _toggleMic,
// //                     ),
// //                     IconButton(
// //                       icon: Icon(_localStream?.getVideoTracks()[0].enabled ?? false
// //                           ? Icons.videocam
// //                           : Icons.videocam_off),
// //                       onPressed: _toggleCamera,
// //                     ),
// //                     IconButton(
// //                       icon: const Icon(Icons.call_end),
// //                       color: Colors.red,
// //                       onPressed: _endCall,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';

// class CallScreen extends StatefulWidget {
//   final bool isCaller;
//   final String roomId;

//   const CallScreen({super.key, required this.isCaller, required this.roomId});

//   @override
//   // ignore: library_private_types_in_public_api
//   _CallScreenState createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   RTCPeerConnection? _peerConnection;
//   MediaStream? _localStream;

//   late WebSocketChannel _channel;

//   @override
//   void initState() {
//     super.initState();
//     _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3000'));
//     initRenderers();
//     _setupSignaling();
//     _createPeerConnection().then((_) {
//       if (widget.isCaller) {
//         _createOffer();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     _peerConnection?.dispose();
//     _localStream?.dispose();
//     _channel.sink.close();
//     super.dispose();
//   }

//   Future<void> initRenderers() async {
//     await _localRenderer.initialize();
//     await _remoteRenderer.initialize();
//   }

//   void _setupSignaling() {
//     _channel.sink.add(jsonEncode({
//       'type': 'createOrJoin',
//       'roomId': widget.roomId,
//     }));

//     _channel.stream.listen((message) {
//       final data = jsonDecode(message);

//       switch (data['type']) {
//         case 'offer':
//           _handleRemoteOffer(data);
//           break;
//         case 'answer':
//           _handleRemoteAnswer(data);
//           break;
//         case 'iceCandidate':
//           _handleRemoteIceCandidate(data);
//           break;
//         case 'calleeJoined':
//           if (widget.isCaller) _createOffer();
//           break;
//         case 'peerLeft':
//           _endCall();
//           break;
//       }
//     });
//   }

//   Future<void> _createPeerConnection() async {
//     final config = {
//       'iceServers': [
//         {'urls': 'stun:stun.l.google.com:19302'},
//       ],
//     };
//     _peerConnection = await createPeerConnection(config, {});

//     _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
//       _channel.sink.add(jsonEncode({
//         'type': 'iceCandidate',
//         'roomId': widget.roomId,
//         'candidate': candidate.toMap(),
//       }));
//     };

//     _peerConnection!.onTrack = (RTCTrackEvent event) {
//       if (event.track.kind == 'video') {
//         setState(() {
//           _remoteRenderer.srcObject = event.streams[0];
//         });
//       }
//     };

//     _localStream = await navigator.mediaDevices.getUserMedia({
//       'audio': true,
//       'video': true,
//     });

//     _localStream!.getTracks().forEach((track) {
//       _peerConnection!.addTrack(track, _localStream!);
//     });

//     setState(() {
//       _localRenderer.srcObject = _localStream;
//     });
//   }

//   Future<void> _createOffer() async {
//     RTCSessionDescription offer = await _peerConnection!.createOffer();
//     await _peerConnection!.setLocalDescription(offer);
//     _channel.sink.add(jsonEncode({
//       'type': 'offer',
//       'roomId': widget.roomId,
//       'offer': offer.toMap(),
//     }));
//   }

//   void _handleRemoteOffer(dynamic data) async {
//     RTCSessionDescription offer = RTCSessionDescription(data['offer']['sdp'], data['offer']['type']);
//     await _peerConnection!.setRemoteDescription(offer);
//     RTCSessionDescription answer = await _peerConnection!.createAnswer();
//     await _peerConnection!.setLocalDescription(answer);
//     _channel.sink.add(jsonEncode({
//       'type': 'answer',
//       'roomId': widget.roomId,
//       'answer': answer.toMap(),
//     }));
//   }

//   void _handleRemoteAnswer(dynamic data) async {
//     RTCSessionDescription answer = RTCSessionDescription(data['answer']['sdp'], data['answer']['type']);
//     await _peerConnection!.setRemoteDescription(answer);
//   }

//   void _handleRemoteIceCandidate(dynamic data) async {
//     RTCIceCandidate candidate = RTCIceCandidate(
//       data['candidate']['candidate'],
//       data['candidate']['sdpMid'],
//       data['candidate']['sdpMLineIndex'],
//     );
//     await _peerConnection!.addIceCandidate(candidate);
//   }

//   void _endCall() {
//     _peerConnection?.close();
//     _localStream?.dispose();
//     _remoteRenderer.srcObject = null;
//     _localRenderer.srcObject = null;
//     _channel.sink.add(jsonEncode({
//       'type': 'leave',
//       'roomId': widget.roomId,
//     }));
//     Navigator.pop(context);
//   }

//   void _toggleMic() {
//     if (_localStream != null) {
//       bool enabled = _localStream!.getAudioTracks()[0].enabled;
//       _localStream!.getAudioTracks()[0].enabled = !enabled;
//       setState(() {});
//     }
//   }

//   void _toggleCamera() {
//     if (_localStream != null) {
//       bool enabled = _localStream!.getVideoTracks()[0].enabled;
//       _localStream!.getVideoTracks()[0].enabled = !enabled;
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('WebRTC Peer-to-Peer Call')),
//       body: OrientationBuilder(
//         builder: (context, orientation) {
//           return Stack(
//             children: [
//               Positioned.fill(
//                 child: RTCVideoView(_remoteRenderer),
//               ),
//               Positioned(
//                 left: 20,
//                 top: 20,
//                 width: 120,
//                 height: 160,
//                 child: Container(
//                   decoration: BoxDecoration(border: Border.all(color: Colors.white)),
//                   child: RTCVideoView(_localRenderer),
//                 ),
//               ),
//               Positioned(
//                 bottom: 20,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                       icon: Icon(_localStream?.getAudioTracks()[0].enabled ?? false
//                           ? Icons.mic
//                           : Icons.mic_off),
//                       onPressed: _toggleMic,
//                     ),
//                     IconButton(
//                       icon: Icon(_localStream?.getVideoTracks()[0].enabled ?? false
//                           ? Icons.videocam
//                           : Icons.videocam_off),
//                       onPressed: _toggleCamera,
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.call_end),
//                       color: Colors.red,
//                       onPressed: _endCall,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// extension on RTCPeerConnection {
//   addIceCandidate(RTCIceCandidate candidate) {}
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class CallScreen extends StatefulWidget {
  final bool isCaller;
  final String roomId;

  const CallScreen({super.key, required this.isCaller, required this.roomId});

  @override
  // ignore: library_private_types_in_public_api
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  late WebSocketChannel _channel;
  bool _isCallStarted = false;
  bool _isLocalStreamReady = false;
  String _debugLog = '';

  void _log(String message) {
    if (kDebugMode) {
      print(message);
    } // For console output
    setState(() {
      _debugLog += '$message\n';
    });
  }

  @override
  void initState() {
    super.initState();
    _log('Initializing call...');
    _initializeCall();
  }

  Future<void> _initializeCall() async {
    try {
      await initRenderers();
      _log('Renderers initialized');

      _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3000'));
      _log('WebSocket connected');

      _setupSignaling();
      _log('Signaling setup complete');

      await _createPeerConnection();
      _log('Peer connection created');

      await _initLocalStream();
      _log('Local stream initialized');

      setState(() {
        _isLocalStreamReady = true;
      });
    } catch (e) {
      _log('Error during initialization: $e');
    }
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _setupSignaling() {
    _channel.sink.add(jsonEncode({
      'type': 'createOrJoin',
      'roomId': widget.roomId,
    }));
    _log('Sent createOrJoin message');

    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      _log('Received message: ${data['type']}');

      switch (data['type']) {
        case 'offer':
          _handleRemoteOffer(data);
          break;
        case 'answer':
          _handleRemoteAnswer(data);
          break;
        case 'iceCandidate':
          _handleRemoteIceCandidate(data);
          break;
        case 'calleeJoined':
          _log('Callee joined, caller can now initiate the call');
          break;
        case 'peerLeft':
          _endCall();
          break;
      }
    });
  }

  Future<void> _createPeerConnection() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };
    _peerConnection = await createPeerConnection(config, {});

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _log('Local ICE candidate: ${candidate.candidate}');
      _channel.sink.add(jsonEncode({
        'type': 'iceCandidate',
        'roomId': widget.roomId,
        'candidate': candidate.toMap(),
      }));
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      _log('Received remote track: ${event.track.kind}');
      if (event.track.kind == 'video') {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };

    _log('Peer connection configuration complete');
  }

  Future<void> _initLocalStream() async {
    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': true,
      });
      _log('Local media stream obtained');

      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      setState(() {
        _localRenderer.srcObject = _localStream;
      });
    } catch (e) {
      _log('Error getting user media: $e');
    }
  }

  Future<void> _createOffer() async {
    _log('Creating offer...');
    try {
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      _log('Local description set');

      _channel.sink.add(jsonEncode({
        'type': 'offer',
        'roomId': widget.roomId,
        'offer': offer.toMap(),
      }));
      _log('Offer sent');
    } catch (e) {
      _log('Error creating offer: $e');
    }
  }

  void _handleRemoteOffer(dynamic data) async {
    _log('Handling remote offer...');
    try {
      RTCSessionDescription offer = RTCSessionDescription(
        data['offer']['sdp'],
        data['offer']['type'],
      );
      await _peerConnection!.setRemoteDescription(offer);
      _log('Remote description set');

      RTCSessionDescription answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      _log('Local description set');

      _channel.sink.add(jsonEncode({
        'type': 'answer',
        'roomId': widget.roomId,
        'answer': answer.toMap(),
      }));
      _log('Answer sent');

      setState(() {
        _isCallStarted = true;
      });
    } catch (e) {
      _log('Error handling remote offer: $e');
    }
  }

  void _handleRemoteAnswer(dynamic data) async {
    _log('Handling remote answer...');
    try {
      RTCSessionDescription answer = RTCSessionDescription(
        data['answer']['sdp'],
        data['answer']['type'],
      );
      await _peerConnection!.setRemoteDescription(answer);
      _log('Remote description set');
    } catch (e) {
      _log('Error handling remote answer: $e');
    }
  }

  void _handleRemoteIceCandidate(dynamic data) async {
    _log('Handling remote ICE candidate...');
    try {
      RTCIceCandidate candidate = RTCIceCandidate(
        data['candidate']['candidate'],
        data['candidate']['sdpMid'],
        data['candidate']['sdpMLineIndex'],
      );
      await _peerConnection!.addIceCandidate(candidate);
      _log('Remote ICE candidate added');
    } catch (e) {
      _log('Error handling remote ICE candidate: $e');
    }
  }

  void _endCall() {
    _log('Ending call...');
    _peerConnection?.close();
    _localStream?.dispose();
    _remoteRenderer.srcObject = null;
    _localRenderer.srcObject = null;
    _channel.sink.add(jsonEncode({
      'type': 'leave',
      'roomId': widget.roomId,
    }));
    setState(() {
      _isCallStarted = false;
    });
    _log('Call ended');
    Navigator.pop(context);
  }

  void _toggleMic() {
    if (_localStream != null) {
      bool enabled = _localStream!.getAudioTracks()[0].enabled;
      _localStream!.getAudioTracks()[0].enabled = !enabled;
      _log('Microphone ${!enabled ? 'unmuted' : 'muted'}');
      setState(() {});
    }
  }

  void _toggleCamera() {
    if (_localStream != null) {
      bool enabled = _localStream!.getVideoTracks()[0].enabled;
      _localStream!.getVideoTracks()[0].enabled = !enabled;
      _log('Camera ${!enabled ? 'enabled' : 'disabled'}');
      setState(() {});
    }
  }

  void _makeCall() {
    if (widget.isCaller && !_isCallStarted) {
      _createOffer();
      setState(() {
        _isCallStarted = true;
      });
      _log('Call initiated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebRTC Peer-to-Peer Call')),
      body: Stack(
        children: [
          Positioned.fill(
            child: _isCallStarted
                ? RTCVideoView(_remoteRenderer)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isCaller
                              ? 'Ready to start the call'
                              : 'Waiting for call to start...',
                          style: const TextStyle(fontSize: 18),
                        ),
                        if (widget.isCaller &&
                            !_isCallStarted &&
                            _isLocalStreamReady)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              onPressed: _makeCall,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Text('Start Call',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
          Positioned(
            left: 20,
            top: 20,
            width: 120,
            height: 160,
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
              child: _isLocalStreamReady
                  ? RTCVideoView(_localRenderer)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          if (_isCallStarted)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                        _localStream?.getAudioTracks()[0].enabled ?? false
                            ? Icons.mic
                            : Icons.mic_off),
                    onPressed: _toggleMic,
                  ),
                  IconButton(
                    icon: Icon(
                        _localStream?.getVideoTracks()[0].enabled ?? false
                            ? Icons.videocam
                            : Icons.videocam_off),
                    onPressed: _toggleCamera,
                  ),
                  IconButton(
                    icon: const Icon(Icons.call_end),
                    color: Colors.red,
                    onPressed: _endCall,
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Container(
              height: 100,
              color: Colors.black.withOpacity(0.7),
              child: SingleChildScrollView(
                child: Text(
                  _debugLog,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.dispose();
    _localStream?.dispose();
    _channel.sink.close();
    _log('Resources disposed');
    super.dispose();
  }
}

extension on RTCPeerConnection {
  addIceCandidate(RTCIceCandidate candidate) {}
}
