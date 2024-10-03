// import 'package:flutter/material.dart';
// import 'models/locations.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Google Offices App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Future<Locations> futureLocations;

//   @override
//   void initState() {
//     super.initState();
//     futureLocations = getGoogleOffices(); // Fetching the data
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google Offices'),
//       ),
//       body: FutureBuilder<Locations>(
//         future: futureLocations,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final offices = snapshot.data!.offices;

//             return ListView.builder(
//               itemCount: offices.length,
//               itemBuilder: (context, index) {
//                 final office = offices[index];

//                 return ListTile(
//                   title: Text(office.name),
//                   subtitle: Text(office.address),
//                   trailing: Text(office.phone),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );
      
      final LatLng latLng = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _markers.clear();
        _markers.add(Marker(
          markerId: const MarkerId('currentLocation'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ));
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15),
      ));
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get current location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Demo'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}




















// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:myapp/screens/otp_screen.dart';
// import 'package:myapp/screens/call_screen.dart';
// import 'package:myapp/screens/profile_screen.dart';
// import 'package:myapp/screens/login_screen.dart';
// import 'package:myapp/screens/signup_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute:
//           FirebaseAuth.instance.currentUser == null ? '/login' : '/profile',
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/otp': (context) => const EmailOTPScreen(),
//         '/signup': (context) => const SignUpScreen(),
//         '/profile': (context) => const ProfileScreen(),
//         '/profile_with_map': (context) => const ProfilePageWithMap(),
        
//       // Add the HomeScreen route
//       },
//       onGenerateRoute: (settings) {
//         if (settings.name == '/call') {
//           final args = settings.arguments as Map<String, dynamic>? ?? {};
//           return MaterialPageRoute(
//             builder: (context) => CallScreen(
//               isCaller: args['isCaller'] ?? false,
//               roomId: args['roomId'] ?? 'default-room',
//             ),
//           );
//         }
//         return null;
//       },
//     );
//   }
// }

// class HomeScreen {
//   const HomeScreen();
// }



































// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _HomeScreenState createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   final TextEditingController _roomIdController = TextEditingController();

// //   void _startCall(bool isCaller) {
// //     if (_roomIdController.text.isNotEmpty) {
// //       Navigator.pushNamed(
// //         context,
// //         '/call',
// //         arguments: {
// //           'isCaller': isCaller,
// //           'roomId': _roomIdController.text,
// //         },
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('WebRTC Call Demo')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             TextField(
// //               controller: _roomIdController,
// //               decoration: const InputDecoration(labelText: 'Room ID'),
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () => _startCall(true),
// //               child: const Text('Start Call (Caller)'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () => _startCall(false),
// //               child: const Text('Join Call (Callee)'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:myapp/screens/otp_screen.dart';
// import 'package:myapp/screens/call_screen.dart';
// import 'package:myapp/screens/profile_screen.dart';
// import 'package:myapp/screens/profile_with_map_screen.dart';
// import 'package:myapp/screens/login_screen.dart';
// import 'package:myapp/screens/signup_screen.dart';
// import 'package:myapp/signaling.dart'; // Import the signaling package for WebRTC functionality

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute:
//           FirebaseAuth.instance.currentUser == null ? '/login' : '/profile',
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/otp': (context) => const EmailOTPScreen(),
//         '/signup': (context) => const SignUpScreen(),
//         '/profile': (context) => const ProfileScreen(),
//         '/profile_with_map': (context) => const ProfilePageWithMap(),
//         '/home': (context) => const HomeScreen(), // HomeScreen with WebRTC call functionality
//       },
//       onGenerateRoute: (settings) {
//         if (settings.name == '/call') {
//           final args = settings.arguments as Map<String, dynamic>? ?? {};
//           return MaterialPageRoute(
//             builder: (context) => CallScreen(
//               isCaller: args['isCaller'] ?? false,
//               roomId: args['roomId'] ?? 'default-room',
//             ),
//           );
//         }
//         return null;
//       },
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _roomIdController = TextEditingController();
//   Signaling signaling = Signaling(); // Create an instance of Signaling for WebRTC

//   void _startCall(bool isCaller) {
//     if (_roomIdController.text.isNotEmpty) {
//       signaling.connect(); // Connect to the signaling server
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               CallScreen(isCaller: isCaller, roomId: _roomIdController.text),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('WebRTC Call Demo')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _roomIdController,
//               decoration: const InputDecoration(labelText: 'Room ID'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _startCall(true), // Start call as a caller
//               child: const Text('Start Call (Caller)'),
//             ),
//             ElevatedButton(
//               onPressed: () => _startCall(false), // Join call as a callee
//               child: const Text('Join Call (Callee)'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



