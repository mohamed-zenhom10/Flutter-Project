import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/util/doctor.dart';
import 'package:main/pages/book_appointment.dart';

class PopularDoctors extends StatefulWidget {
  const PopularDoctors({super.key});

  @override
  State<PopularDoctors> createState() => _PopularDoctors();
}

class _PopularDoctors extends State<PopularDoctors> {
  String selectedSpecialty = 'All';

  final List<String> specialties = [
    'All',
    'Cardiology',
    'Neurology',
    'Dermatology',
    'Orthopedics',
    'Pediatrics',
    'Ophthalmology',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Popular Doctors"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Specialty filter chips
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: specialties.length,
              itemBuilder: (context, index) {
                final isSelected = selectedSpecialty == specialties[index];
                return GestureDetector(
                  onTap: () => setState(() => selectedSpecialty = specialties[index]),
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurpleAccent : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      specialties[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Doctors list
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
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No doctors found"));
                }

                final doctors = snapshot.data!.docs.map((doc) {
                  return Doctor.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                return ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 2)],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(doctor.image),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(doctor.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(doctor.specialization, style: TextStyle(color: Colors.grey, fontSize: 14)),
                                Text(doctor.hospital, style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    Text(' ${doctor.rate}', style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 10),
                                    Icon(Icons.work, color: Colors.grey, size: 14),
                                    Text(' ${doctor.experience} yrs', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookAppointment(doctor: doctor),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text("Book", style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
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