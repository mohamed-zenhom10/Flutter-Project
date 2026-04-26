import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/pages/popular_doctors.dart';
import 'package:main/util/doctor.dart';
import 'package:main/widgets/doctor_carousel.dart';
import 'package:main/pages/my_appointments.dart';
import 'package:main/pages/search_screen.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  TextEditingController searchValue = TextEditingController();
  String username = "there";

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() => username = doc['username'] ?? 'there');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Good day! 👋", style: TextStyle(color: Colors.white70, fontSize: 14)),
                            Text(username, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.calendar_month, color: Colors.white),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppointments())),
                            ),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person, color: Colors.white, size: 24),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("How are you feeling\ntoday?", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1.3)),
                    SizedBox(height: 20),
                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchScreen()),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search a doctor, specialty...",
                                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Specialties quick access
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Specialties", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              SizedBox(height: 14),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSpecialtyCard(Icons.favorite, "Cardiology", Colors.red.shade100, Colors.red),
                    _buildSpecialtyCard(Icons.psychology, "Neurology", Colors.purple.shade100, Colors.purple),
                    _buildSpecialtyCard(Icons.face, "Dermatology", Colors.orange.shade100, Colors.orange),
                    _buildSpecialtyCard(Icons.accessibility_new, "Orthopedics", Colors.green.shade100, Colors.green),
                    _buildSpecialtyCard(Icons.child_care, "Pediatrics", Colors.blue.shade100, primaryBlue),
                    _buildSpecialtyCard(Icons.remove_red_eye, "Ophthalmology", Colors.teal.shade100, Colors.teal),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Popular Doctors
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Popular Doctors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PopularDoctors())),
                      child: Text("See all", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('doctors').limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: primaryBlue));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No doctors found"));
                  }
                  final doctors = snapshot.data!.docs.map((doc) {
                    return Doctor.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
                  }).toList();
                  return DoctorCarousel(allDoctors: doctors);
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyCard(IconData icon, String label, Color bgColor, Color iconColor) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PopularDoctors(initialSpecialty: label)),
      ),
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2),
          ],
        ),
      ),
    );
  }
}