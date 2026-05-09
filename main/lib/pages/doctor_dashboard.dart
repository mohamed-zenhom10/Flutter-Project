import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/screens/LoginScreen.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class DoctorDashboard extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorDashboard({super.key, required this.doctorData});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboard();
}

class _DoctorDashboard extends State<DoctorDashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: currentIndex == 0
          ? AppointmentsTab(doctorData: widget.doctorData)
          : OffDaysTab(doctorData: widget.doctorData),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_busy),
            label: 'Off Days',
          ),
        ],
      ),
    );
  }
}

// Appointments Tab
class AppointmentsTab extends StatelessWidget {
  final Map<String, dynamic> doctorData;
  const AppointmentsTab({super.key, required this.doctorData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back! 👋",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        doctorData['name'] ?? 'Doctor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.logout, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Manage your appointments",
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
                .where('doctorId', isEqualTo: doctorData['doctorId'])
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
                          Icons.calendar_today,
                          size: 60,
                          color: primaryBlue,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "No appointments yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                  final appointmentId = appointments[index].id;
                  final date = (data['date'] as Timestamp).toDate();
                  final isPast = date.isBefore(DateTime.now());

                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
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
                    ),
                    child: Column(
                      children: [
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: primaryBlue,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Patient Appointment",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPast
                                          ? Colors.grey.shade100
                                          : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isPast ? 'Completed' : 'Upcoming',
                                      style: TextStyle(
                                        color: isPast
                                            ? Colors.grey
                                            : Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: primaryBlue,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '${date.day}/${date.month}/${date.year}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Icon(
                                    Icons.access_time,
                                    color: primaryBlue,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    data['time'],
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              if (data['confirmationCode'] != null) ...[
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.confirmation_number,
                                      color: primaryBlue,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Code: ${data['confirmationCode']}',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (!isPast) ...[
                                SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Cancel Appointment"),
                                          content: Text(
                                            "Are you sure you want to cancel this appointment?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text("No"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await FirebaseFirestore.instance
                                            .collection('appointments')
                                            .doc(appointmentId)
                                            .delete();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    label: Text(
                                      "Cancel Appointment",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.red.shade200,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
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
    );
  }
}

// Off Days Tab
class OffDaysTab extends StatefulWidget {
  final Map<String, dynamic> doctorData;
  const OffDaysTab({super.key, required this.doctorData});

  @override
  State<OffDaysTab> createState() => _OffDaysTab();
}

class _OffDaysTab extends State<OffDaysTab> {
  List<DateTime> offDays = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOffDays();
  }

  Future<void> fetchOffDays() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('off_days')
        .where('doctorId', isEqualTo: widget.doctorData['doctorId'])
        .get();

    setState(() {
      offDays = snapshot.docs.map((doc) {
        final timestamp = doc['date'] as Timestamp;
        return timestamp.toDate();
      }).toList();
      isLoading = false;
    });
  }

  Future<void> addOffDay(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);

    // Check if already added
    if (offDays.any(
      (d) => d.day == date.day && d.month == date.month && d.year == date.year,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This day is already marked as off!"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('off_days').add({
      'doctorId': widget.doctorData['doctorId'],
      'date': Timestamp.fromDate(startOfDay),
    });

    setState(() => offDays.add(startOfDay));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Off day added!"), backgroundColor: Colors.green),
    );
  }

  Future<void> removeOffDay(DateTime date) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('off_days')
        .where('doctorId', isEqualTo: widget.doctorData['doctorId'])
        .where(
          'date',
          isEqualTo: Timestamp.fromDate(
            DateTime(date.year, date.month, date.day),
          ),
        )
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    setState(
      () => offDays.removeWhere(
        (d) =>
            d.day == date.day && d.month == date.month && d.year == date.year,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Off day removed!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Off Days",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Set days when you're not available",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      builder: (context, child) => Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(primary: primaryBlue),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) addOffDay(picked);
                  },
                  icon: Icon(Icons.add, color: primaryBlue),
                  label: Text(
                    "Add Off Day",
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: primaryBlue))
              : offDays.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_available, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "No off days set",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: offDays.length,
                  itemBuilder: (context, index) {
                    final day = offDays[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade200, blurRadius: 5),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.event_busy,
                              color: Colors.red,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${day.day}/${day.month}/${day.year}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeOffDay(day),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
