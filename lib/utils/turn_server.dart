class TurnServerConfig {
  get iceServers => null;

  // Function to return the configuration for WebRTC PeerConnection
  static Map<String, dynamic> getTurnConfig() {
    return {
      'iceServers': [
        // STUN server (Google's free STUN server)
        {
          'urls': 'stun:stun.l.google.com:19302',
        },

        // TURN server configuration (replace with your actual TURN server details)
        {
          'urls': 'turn:your.turn.server:3478',  // Your TURN server URL and port
          'username': 'your-username',           // TURN server username
          'credential': 'your-password',         // TURN server password
        },
      ],
    };
  }
}
