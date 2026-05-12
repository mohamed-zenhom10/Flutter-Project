import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:main/pages/doctor_profile.dart';
import '../util/doctor.dart';

const Color primaryBlue = Color(0xFF2D81FF);

bool isFemaleDoctor(String name) {
  final femaleNames = ['sarah', 'emily', 'lisa', 'maria', 'nadia', 'mona', 'heba', 'yasmin', 'dina', 'noha', 'rania', 'amira', 'salma', 'rana', 'mariam', 'ghada'];
  final firstName = name.toLowerCase().replaceAll('dr. ', '').split(' ')[0];
  return femaleNames.contains(firstName);
}

Widget doctorAvatar(String name, double radius) {
  final female = isFemaleDoctor(name);
  return CircleAvatar(
    radius: radius,
    backgroundColor: female ? Colors.pink.shade50 : Colors.blue.shade50,
    child: Icon(
      female ? Icons.face_3 : Icons.face,
      size: radius,
      color: female ? Colors.pink : primaryBlue,
    ),
  );
}

class DoctorCarousel extends StatelessWidget {
  final List<Doctor> allDoctors;

  const DoctorCarousel({super.key, required this.allDoctors});

  @override
  Widget build(BuildContext context) {
    final topDoctors = List<Doctor>.from(allDoctors)
      ..sort((a, b) => b.rate.compareTo(a.rate));
    final top5Doctors = topDoctors.take(5).toList();

    return CarouselSlider(
      options: CarouselOptions(height: 280, autoPlay: false, enlargeCenterPage: true),
      items: top5Doctors.map((doctor) => _buildDoctorCard(context, doctor)).toList(),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          doctorAvatar(doctor.name, 42),
          SizedBox(height: 8),
          Text(
            doctor.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            doctor.specialization,
            style: TextStyle(color: primaryBlue, fontSize: 13, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 3),
                    Text('${doctor.rate}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'EGP ${doctor.fee}',
                    style: TextStyle(color: primaryBlue, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorProfile(doctor: doctor)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: Text("View Profile", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
