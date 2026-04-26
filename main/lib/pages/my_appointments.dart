import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/util/AppDialog.dart';

const Color primaryBlue = Color(0xFF2D81FF);

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
      backgroundColor: Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Blue header
          Container(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 25),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        "My Appointments",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Manage your upcoming appointments",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Appointments list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('userId', isEqualTo: user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: primaryBlue));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.calendar_today, size: 60, color: primaryBlue),
                        ),
                        SizedBox(height: 20),
                        Text("No appointments yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        SizedBox(height: 8),
                        Text("Book your first appointment!", style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, spreadRadius: 2)],
                      ),
                      child: Column(
                        children: [
                          // Top colored bar
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: isPast ? Colors.grey.shade300 : primaryBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data['doctorName'],
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: isPast ? Colors.grey.shade100 : Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: isPast ? Colors.grey.shade300 : Colors.green.shade200),
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
                                SizedBox(height: 12),
                                // Info rows
                                _infoRow(Icons.medical_services, data['specialization']),
                                SizedBox(height: 6),
                                _infoRow(Icons.local_hospital, data['hospital']),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    _infoChip(Icons.calendar_today, '${date.day}/${date.month}/${date.year}'),
                                    SizedBox(width: 10),
                                    _infoChip(Icons.access_time, data['time']),
                                  ],
                                ),
                                if (!isPast) ...[
                                  SizedBox(height: 14),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: OutlinedButton.icon(
                                      onPressed: () => cancelAppointment(appointmentId),
                                      icon: Icon(Icons.cancel_outlined, color: Colors.red, size: 18),
                                      label: Text("Cancel Appointment", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.red.shade200),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
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

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: primaryBlue, size: 16),
        SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
      ],
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue, size: 13),
          SizedBox(width: 5),
          Text(text, style: TextStyle(color: primaryBlue, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}