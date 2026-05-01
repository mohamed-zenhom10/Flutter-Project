import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/util/doctor.dart';
import 'package:main/pages/book_appointment.dart';
import 'package:main/pages/doctor_profile.dart';
import 'package:main/widgets/doctor_carousel.dart';
import 'package:main/widgets/doctor_carousel.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class PopularDoctors extends StatefulWidget {
  final String? initialSpecialty;
  const PopularDoctors({super.key, this.initialSpecialty});

  @override
  State<PopularDoctors> createState() => _PopularDoctors();
}

class _PopularDoctors extends State<PopularDoctors> {
  late String selectedSpecialty;

  @override
  void initState() {
    super.initState();
    selectedSpecialty = widget.initialSpecialty ?? 'All';
  }

  final List<String> specialties = [
    'All', 'Cardiology', 'Neurology', 'Dermatology',
    'Orthopedics', 'Pediatrics', 'Ophthalmology',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Find a Doctor", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: primaryBlue,
            child: Column(
              children: [
                SizedBox(
                  height: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    itemCount: specialties.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedSpecialty == specialties[index];
                      return GestureDetector(
                        onTap: () => setState(() => selectedSpecialty = specialties[index]),
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            specialties[index],
                            style: TextStyle(
                              color: isSelected ? primaryBlue : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedSpecialty == 'All'
                  ? FirebaseFirestore.instance.collection('doctors').snapshots()
                  : FirebaseFirestore.instance
                  .collection('doctors')
                  .where('specialization', isEqualTo: selectedSpecialty)
                  .snapshots(),
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

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorProfile(doctor: doctor)),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, spreadRadius: 2)],
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryBlue.withOpacity(0.2), width: 2),
                              ),
                              child: doctorAvatar(doctor.name, 35),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doctor.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                                  SizedBox(height: 3),
                                  Text(doctor.specialization, style: TextStyle(color: primaryBlue, fontSize: 13, fontWeight: FontWeight.w500)),
                                  Text(doctor.hospital, style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 15),
                                      Text(' ${doctor.rate}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      SizedBox(width: 10),
                                      Icon(Icons.work_outline, color: Colors.grey, size: 13),
                                      Text(' ${doctor.experience} yrs', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 70,
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BookAppointment(doctor: doctor)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                ),
                                child: Text("Book", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}