import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/firebase_options.dart';
import 'package:main/screens/splash_screen.dart';
import 'package:main/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/pages/doctor_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Appointment App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoading = true;
  bool isDoctor = false;
  Map<String, dynamic>? doctorData;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;

      if (user == null) {
        setState(() {
          isLoading = false;
          isDoctor = false;
        });
        return;
      }

      // Always show loading while checking
      setState(() => isLoading = true);

      final doctorSnapshot = await FirebaseFirestore.instance
          .collection('doctors_accounts')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isDoctor = doctorSnapshot.docs.isNotEmpty;
        if (isDoctor) {
          doctorData = doctorSnapshot.docs.first.data() as Map<String, dynamic>;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return SplashScreen();
    if (isDoctor && doctorData != null)
      return DoctorDashboard(doctorData: doctorData!);
    return HomePage();
  }
}
