import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/util/doctor.dart';
import 'package:main/util/AppDialog.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class BookAppointment extends StatefulWidget {
  final Doctor doctor;
  const BookAppointment({super.key, required this.doctor});

  @override
  State<BookAppointment> createState() => _BookAppointment();
}

class _BookAppointment extends State<BookAppointment> {
  DateTime? selectedDate;
  String? selectedTime;
  bool isLoading = false;
  List<String> bookedSlots = [];

  final List<String> timeSlots = [
    '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM',
    '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
    '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM',
  ];

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: primaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTime = null;
        bookedSlots = [];
      });
      await fetchBookedSlots(picked);
    }
  }

  Future<void> fetchBookedSlots(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));
    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctorId', isEqualTo: widget.doctor.id)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .get();
    setState(() {
      bookedSlots = snapshot.docs.map((doc) => doc['time'] as String).toList();
    });
  }

  Future<void> bookAppointment() async {
    if (selectedDate == null) {
      AppDialogs.showErrorDialog(context, 'Error', 'Please select a date');
      return;
    }
    if (selectedTime == null) {
      AppDialogs.showErrorDialog(context, 'Error', 'Please select a time slot');
      return;
    }
    setState(() => isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      await fetchBookedSlots(selectedDate!);
      if (bookedSlots.contains(selectedTime)) {
        setState(() => isLoading = false);
        AppDialogs.showErrorDialog(context, 'Error', 'This slot was just booked! Please choose another.');
        return;
      }
      await FirebaseFirestore.instance.collection('appointments').add({
        'userId': user!.uid,
        'doctorId': widget.doctor.id,
        'doctorName': widget.doctor.name,
        'specialization': widget.doctor.specialization,
        'hospital': widget.doctor.hospital,
        'date': Timestamp.fromDate(selectedDate!),
        'time': selectedTime,
        'status': 'pending',
        'createdAt': Timestamp.now(),
      });
      setState(() => isLoading = false);
      AppDialogs.showErrorDialog(context, 'Success', 'Appointment booked successfully!');
    } catch (e) {
      setState(() => isLoading = false);
      AppDialogs.showErrorDialog(context, 'Error', 'Failed to book appointment. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Blue header with doctor info
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
                      child: Text("Book Appointment",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                SizedBox(height: 20),
                // Doctor card
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(widget.doctor.image),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.doctor.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                            Text(widget.doctor.specialization, style: TextStyle(color: Colors.white70, fontSize: 14)),
                            Text(widget.doctor.hospital, style: TextStyle(color: Colors.white60, fontSize: 12)),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Text(' ${widget.doctor.rate}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                SizedBox(width: 10),
                                Icon(Icons.work_outline, color: Colors.white70, size: 14),
                                Text(' ${widget.doctor.experience} yrs', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date picker
                  Text("Select Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.calendar_today, color: primaryBlue, size: 20),
                          ),
                          SizedBox(width: 12),
                          Text(
                            selectedDate == null ? 'Choose a date' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                            style: TextStyle(fontSize: 15, color: selectedDate == null ? Colors.grey : Colors.black87, fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Time slots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      if (selectedDate != null)
                        Row(
                          children: [
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.red.shade300, borderRadius: BorderRadius.circular(2))),
                            SizedBox(width: 4),
                            Text("Booked", style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedTime == timeSlots[index];
                      final isBooked = bookedSlots.contains(timeSlots[index]);
                      return GestureDetector(
                        onTap: isBooked ? null : () => setState(() => selectedTime = timeSlots[index]),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isBooked ? Colors.red.shade100 : isSelected ? primaryBlue : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isBooked ? Colors.red.shade300 : isSelected ? primaryBlue : Colors.grey.shade200,
                            ),
                            boxShadow: isSelected ? [BoxShadow(color: primaryBlue.withOpacity(0.3), blurRadius: 6)] : [],
                          ),
                          child: Center(
                            child: Text(
                              timeSlots[index],
                              style: TextStyle(
                                color: isBooked ? Colors.red.shade700 : isSelected ? Colors.white : Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : bookAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Confirm Booking", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}