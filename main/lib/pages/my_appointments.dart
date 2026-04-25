import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/util/AppDialog.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({super.key});

  @override
  State<MyAppointments> createState() => _MyAppointments();
}

class _MyAppointments extends State<MyAppointments> {
  Future<void> cancelAppointment(String appointmentId) async {
    AppDialogs.showConfirmationDialog(
      context,
      'Cancel Appointment',
      'Are you sure you want to cancel this appointment?',
          () async {
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appointmentId)
            .delete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("My Appointments"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 80, color: Colors.grey),
                  SizedBox(height: 15),
                  Text("No appointments yet", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final data = appointments[index].data() as Map<String, dynamic>;
              final appointmentId = appointments[index].id;
              final date = (data['date'] as Timestamp).toDate();
              final isPast = date.isBefore(DateTime.now());

              return Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 2)],
                  border: Border.all(
                    color: isPast ? Colors.grey.shade300 : Colors.deepPurpleAccent.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['doctorName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPast ? Colors.grey.shade200 : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isPast ? 'Completed' : 'Upcoming',
                            style: TextStyle(
                              color: isPast ? Colors.grey : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.medical_services, color: Colors.deepPurpleAccent, size: 16),
                        SizedBox(width: 5),
                        Text(data['specialization'], style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.local_hospital, color: Colors.deepPurpleAccent, size: 16),
                        SizedBox(width: 5),
                        Text(data['hospital'], style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.deepPurpleAccent, size: 16),
                        SizedBox(width: 5),
                        Text('${date.day}/${date.month}/${date.year}', style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 15),
                        Icon(Icons.access_time, color: Colors.deepPurpleAccent, size: 16),
                        SizedBox(width: 5),
                        Text(data['time'], style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    if (!isPast) ...[
                      SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => cancelAppointment(appointmentId),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text("Cancel Appointment", style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}