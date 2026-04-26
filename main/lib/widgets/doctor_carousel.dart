import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:main/pages/doctor_profile.dart';
import '../util/doctor.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class DoctorCarousel extends StatelessWidget {
  final List<Doctor> allDoctors;

  const DoctorCarousel({super.key, required this.allDoctors});

  @override
  Widget build(BuildContext context) {
    final topDoctors = List<Doctor>.from(allDoctors)
      ..sort((a, b) => b.rate.compareTo(a.rate));
    final top5Doctors = topDoctors.take(5).toList();

    return CarouselSlider(
      options: CarouselOptions(height: 220, autoPlay: false, enlargeCenterPage: true),
      items: top5Doctors.map((doctor) => _buildDoctorCard(context, doctor)).toList(),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorProfile(doctor: doctor)),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, spreadRadius: 2)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(doctor.image),
            ),
            SizedBox(height: 10),
            Text(doctor.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text(doctor.specialization, style: TextStyle(color: primaryBlue, fontSize: 13)),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' ${doctor.rate}', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}