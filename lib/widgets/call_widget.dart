import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallWidget extends StatelessWidget {
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;

  const CallWidget({super.key, required this.localRenderer, required this.remoteRenderer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RTCVideoView(localRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
        ),
        Expanded(
          child: RTCVideoView(remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
        ),
      ],
    );
  }
}
