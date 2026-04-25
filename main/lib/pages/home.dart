import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/pages/popular_doctors.dart';
import 'package:main/util/doctor.dart';
import 'package:main/widgets/doctor_carousel.dart';
import 'package:main/pages/my_appointments.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  TextEditingController searchValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Home Page"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_month, color: Colors.deepPurpleAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAppointments()),
                );
              },
            ),
          ],
        ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello!", style: TextStyle(fontSize: 22)),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset("assets/user_img.png"),
                  )
                ],
              ),
              SizedBox(height: 15),
              Text("Keep taking care of your health", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              TextField(
                controller: searchValue,
                decoration: InputDecoration(
                  labelText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Popular Doctors", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PopularDoctors()));
                    },
                    child: Text("See all", style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 18)),
                  ),
                ],
              ),
              SizedBox(height: 15),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('doctors').limit(5).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No doctors found");
                  }
                  final doctors = snapshot.data!.docs.map((doc) {
                    return Doctor.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
                  }).toList();
                  return DoctorCarousel(allDoctors: doctors);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}