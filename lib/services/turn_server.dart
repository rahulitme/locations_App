class TurnServerConfig {
  get iceServers => null;

  static Map<String, dynamic> getTurnConfig() {
    return {
      'iceServers': [
        // STUN server
        {'urls': 'stun:stun.l.google.com:19302'},

        // TURN server (replace with your actual TURN server credentials)
        {
          'urls': 'turn:your.turn.server:3478', // Your TURN server URL
          'username': 'your-username', // TURN server username
          'credential': 'your-password', // TURN server password
        },
      ],
    };
  }
}
