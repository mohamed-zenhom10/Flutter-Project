import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    "Notifications",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),

          // Notifications list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('userId', isEqualTo: user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: primaryBlue),
                  );
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
                          child: Icon(
                            Icons.notifications_none,
                            size: 60,
                            color: primaryBlue,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "No notifications yet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Book an appointment to get notified!",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final appointments = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final data =
                        appointments[index].data() as Map<String, dynamic>;
                    final date = (data['date'] as Timestamp).toDate();
                    final isPast = date.isBefore(DateTime.now());
                    final isToday =
                        date.day == DateTime.now().day &&
                        date.month == DateTime.now().month &&
                        date.year == DateTime.now().year;

                    String notifTitle;
                    String notifMessage;
                    IconData notifIcon;
                    Color notifColor;

                    if (isPast) {
                      notifTitle = "Appointment Completed";
                      notifMessage =
                          "Your appointment with ${data['doctorName']} on ${date.day}/${date.month}/${date.year} at ${data['time']} is completed.";
                      notifIcon = Icons.check_circle;
                      notifColor = Colors.green;
                    } else if (isToday) {
                      notifTitle = "Appointment Today! 🔔";
                      notifMessage =
                          "You have an appointment with ${data['doctorName']} today at ${data['time']}. Don't forget!";
                      notifIcon = Icons.alarm;
                      notifColor = Colors.orange;
                    } else {
                      notifTitle = "Upcoming Appointment";
                      notifMessage =
                          "You have an appointment with ${data['doctorName']} on ${date.day}/${date.month}/${date.year} at ${data['time']}.";
                      notifIcon = Icons.calendar_today;
                      notifColor = primaryBlue;
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(color: notifColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: notifColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(notifIcon, color: notifColor, size: 22),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notifTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  notifMessage,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_hospital,
                                      color: Colors.grey,
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      data['hospital'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: notifColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        isPast
                                            ? 'Completed'
                                            : isToday
                                            ? 'Today'
                                            : 'Upcoming',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: notifColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
}
