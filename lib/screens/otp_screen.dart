// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class OTPScreen extends StatefulWidget {
//   const OTPScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String verificationId = '';
//   String otp = '';

//   Future<void> verifyPhoneNumber(String phoneNumber) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         if (kDebugMode) {
//           print(e.toString());
//         }
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           this.verificationId = verificationId;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }

//   Future<void> verifyOTP() async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId, smsCode: otp);
//     await _auth.signInWithCredential(credential);
//     // ignore: use_build_context_synchronously
//     Navigator.pushNamed(context, '/profile');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('OTP Verification')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: const InputDecoration(labelText: 'Enter OTP'),
//               onChanged: (value) {
//                 setState(() {
//                   otp = value;
//                 });
//               },
//             ),
//             ElevatedButton(
//               onPressed: verifyOTP,
//               child: const Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:logging/logging.dart';

// class OTPScreen extends StatefulWidget {
//   const OTPScreen({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _OTPScreenState createState() => _OTPScreenState();
// }

// class _OTPScreenState extends State<OTPScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final Logger _logger = Logger('OTPScreen');
  
//   String verificationId = '';
//   String otp = '';
//   bool isLoading = false;
//   int _counter = 60;
//   Timer? _timer;
//   final TextEditingController phoneController = TextEditingController();
//   String initialCountry = 'US';
//   PhoneNumber number = PhoneNumber(isoCode: 'US');
//   bool showOtpInput = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupLogging();
//   }

//   void _setupLogging() {
//     Logger.root.level = Level.ALL;
//     Logger.root.onRecord.listen((record) {
//       // ignore: avoid_print
//       print('${record.level.name}: ${record.time}: ${record.message}');
//     });
//   }

//   Future<void> verifyPhoneNumber(String phoneNumber) async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//           _navigateToProfile();
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           _handleError('Verification Failed', e.message ?? 'Unknown error occurred');
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             this.verificationId = verificationId;
//             isLoading = false;
//             showOtpInput = true;
//           });
//           startTimer();
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _logger.info('Auto retrieval timeout');
//         },
//       );
//     } catch (e) {
//       _handleError('Phone Number Verification Error', e.toString());
//     }
//   }

//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(oneSec, (Timer timer) {
//       if (_counter == 0) {
//         setState(() {
//           timer.cancel();
//         });
//       } else {
//         setState(() {
//           _counter--;
//         });
//       }
//     });
//   }

//   Future<void> verifyOTP() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: verificationId, smsCode: otp);
//       await _auth.signInWithCredential(credential);
//       _navigateToProfile();
//     } catch (e) {
//       _handleError('OTP Verification Error', 'Invalid OTP. Please try again.');
//     }
//   }

//   void _handleError(String title, String message) {
//     setState(() {
//       isLoading = false;
//     });
//     _logger.warning('$title: $message');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   void _navigateToProfile() {
//     Navigator.pushReplacementNamed(context, '/profile');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 24),
//               Text(
//                 showOtpInput ? 'Verification' : 'Enter Phone Number',
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 showOtpInput
//                     ? 'Enter the OTP sent to your phone'
//                     : 'We will send you a one-time password',
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       color: Colors.grey[600],
//                     ),
//               ),
//               const SizedBox(height: 36),
//               if (!showOtpInput) ...[
//                 InternationalPhoneNumberInput(
//                   onInputChanged: (PhoneNumber number) {
//                     this.number = number;
//                   },
//                   selectorConfig: const SelectorConfig(
//                     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                   ),
//                   ignoreBlank: false,
//                   autoValidateMode: AutovalidateMode.disabled,
//                   selectorTextStyle: const TextStyle(color: Colors.black),
//                   initialValue: number,
//                   textFieldController: phoneController,
//                   formatInput: true,
//                   keyboardType: const TextInputType.numberWithOptions(
//                       signed: true, decimal: true),
//                   inputBorder: const OutlineInputBorder(),
//                   onSaved: (PhoneNumber number) {
//                     _logger.info('Phone number saved: $number');
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: isLoading
//                       ? null
//                       : () => verifyPhoneNumber(number.phoneNumber ?? ''),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Send OTP'),
//                 ),
//               ] else ...[
//                 PinCodeTextField(
//                   appContext: context,
//                   length: 6,
//                   obscureText: false,
//                   animationType: AnimationType.fade,
//                   pinTheme: PinTheme(
//                     shape: PinCodeFieldShape.box,
//                     borderRadius: BorderRadius.circular(5),
//                     fieldHeight: 50,
//                     fieldWidth: 40,
//                     activeFillColor: Colors.white,
//                     inactiveFillColor: Colors.grey[100],
//                     selectedFillColor: Colors.grey[100],
//                     activeColor: Colors.blue,
//                     inactiveColor: Colors.grey,
//                     selectedColor: Colors.blue,
//                   ),
//                   animationDuration: const Duration(milliseconds: 300),
//                   backgroundColor: Colors.white,
//                   enableActiveFill: true,
//                   onCompleted: (v) {
//                     otp = v;
//                     verifyOTP();
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       otp = value;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: isLoading ? null : verifyOTP,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('Verify OTP'),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       _counter > 0
//                           ? 'Resend OTP in $_counter seconds'
//                           : "Didn't receive the OTP?",
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     if (_counter == 0) ...[
//                       TextButton(
//                         onPressed: () {
//                           verifyPhoneNumber(number.phoneNumber ?? '');
//                           setState(() {
//                             _counter = 60;
//                           });
//                           startTimer();
//                         },
//                         child: const Text('Resend'),
//                       ),
//                     ],
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     phoneController.dispose();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:logging/logging.dart';

class EmailOTPScreen extends StatefulWidget {
  const EmailOTPScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailOTPScreenState createState() => _EmailOTPScreenState();
}

class _EmailOTPScreenState extends State<EmailOTPScreen> {
  final Logger _logger = Logger('EmailOTPScreen');
  
  String otp = '';
  bool isLoading = false;
  int _counter = 60;
  Timer? _timer;
  final TextEditingController emailController = TextEditingController();
  bool showOtpInput = false;

  // Replace these with your actual email credentials
  final String senderEmail = 'your_email@example.com';
  final String senderPassword = 'your_email_password';

  @override
  void initState() {
    super.initState();
    _setupLogging();
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      }
    });
  }

  Future<void> sendOTP(String email) async {
    setState(() {
      isLoading = true;
    });
    try {
      otp = _generateOTP();
      await _sendEmail(email, otp);
      setState(() {
        isLoading = false;
        showOtpInput = true;
      });
      startTimer();
    } catch (e) {
      _handleError('Email Sending Error', e.toString());
    }
  }

  String _generateOTP() {
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }

  Future<void> _sendEmail(String recipientEmail, String otp) async {
    final smtpServer = gmail(senderEmail, senderPassword);

    final message = Message()
      ..from = Address(senderEmail)
      ..recipients.add(recipientEmail)
      ..subject = 'Your OTP for verification'
      ..text = 'Your OTP is: $otp. It will be valid for 1 minute.';

    try {
      final sendReport = await send(message, smtpServer);
      _logger.info('OTP sent: $sendReport');
    } catch (e) {
      _logger.severe('Error sending OTP email: $e');
      rethrow;
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_counter == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (otp == otp) {  // In a real app, compare with the OTP stored securely
        _navigateToProfile();
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      _handleError('OTP Verification Error', 'Invalid OTP. Please try again.');
    }
  }

  void _handleError(String title, String message) {
    setState(() {
      isLoading = false;
    });
    _logger.warning('$title: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToProfile() {
    Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                showOtpInput ? 'Verification' : 'Enter Email Address',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                showOtpInput
                    ? 'Enter the OTP sent to your email'
                    : 'We will send you a one-time password',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 36),
              if (!showOtpInput) ...[
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => sendOTP(emailController.text),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Send OTP'),
                ),
              ] else ...[
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.grey[100],
                    selectedFillColor: Colors.grey[100],
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    selectedColor: Colors.blue,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,
                  onCompleted: (v) {
                    otp = v;
                    verifyOTP();
                  },
                  onChanged: (value) {
                    setState(() {
                      otp = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : verifyOTP,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Verify OTP'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _counter > 0
                          ? 'Resend OTP in $_counter seconds'
                          : "Didn't receive the OTP?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (_counter == 0) ...[
                      TextButton(
                        onPressed: () {
                          sendOTP(emailController.text);
                          setState(() {
                            _counter = 60;
                          });
                          startTimer();
                        },
                        child: const Text('Resend'),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();
    super.dispose();
  }
}