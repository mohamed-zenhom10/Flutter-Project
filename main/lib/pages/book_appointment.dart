import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/util/doctor.dart';
import 'package:main/util/AppDialog.dart';

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

      // Double check slot is still available
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Book Appointment"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor info card
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(widget.doctor.image),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.doctor.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(widget.doctor.specialization, style: TextStyle(color: Colors.grey)),
                        Text(widget.doctor.hospital, style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(' ${widget.doctor.rate}', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // Date picker
              Text("Select Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: pickDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.deepPurpleAccent),
                      SizedBox(width: 10),
                      Text(
                        selectedDate == null
                            ? 'Choose a date'
                            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        style: TextStyle(fontSize: 16, color: selectedDate == null ? Colors.grey : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),

              // Time slots
              Text("Select Time", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              if (selectedDate != null)
                Row(
                  children: [
                    Container(width: 12, height: 12, color: Colors.red.shade200),
                    SizedBox(width: 5),
                    Text("Already booked", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(width: 15),
                    Container(width: 12, height: 12, color: Colors.deepPurpleAccent),
                    SizedBox(width: 5),
                    Text("Selected", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                        color: isBooked
                            ? Colors.red.shade200
                            : isSelected
                            ? Colors.deepPurpleAccent
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isBooked
                              ? Colors.red.shade300
                              : isSelected
                              ? Colors.deepPurpleAccent
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          timeSlots[index],
                          style: TextStyle(
                            color: isBooked ? Colors.white : isSelected ? Colors.white : Colors.black,
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

              // Book button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : bookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Confirm Booking", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}