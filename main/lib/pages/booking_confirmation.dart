import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/util/doctor.dart';
import 'package:main/pages/home.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class BookingConfirmation extends StatelessWidget {
  final Doctor doctor;
  final String date;
  final String time;
  final String confirmationCode;

  const BookingConfirmation({
    super.key,
    required this.doctor,
    required this.date,
    required this.time,
    required this.confirmationCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 20),
              // Success animation
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, color: Colors.green, size: 60),
              ),
              SizedBox(height: 20),
              Text(
                "Booking Confirmed!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                "Your appointment has been successfully booked",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              SizedBox(height: 30),

              // Confirmation code card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      "Confirmation Code",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          confirmationCode,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 6,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: confirmationCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Code copied to clipboard!"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.copy, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Show this code at the clinic",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Appointment details card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, spreadRadius: 2)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Appointment Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    SizedBox(height: 16),
                    // Doctor info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(doctor.image),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doctor.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(doctor.specialization, style: TextStyle(color: primaryBlue, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey.shade100),
                    SizedBox(height: 12),
                    _detailRow(Icons.local_hospital, "Hospital", doctor.hospital),
                    SizedBox(height: 10),
                    _detailRow(Icons.calendar_today, "Date", date),
                    SizedBox(height: 10),
                    _detailRow(Icons.access_time, "Time", time),
                    SizedBox(height: 10),
                    _detailRow(Icons.payments, "Fee", "EGP ${doctor.fee}"),
                    SizedBox(height: 10),
                    _detailRow(Icons.location_on, "Address", doctor.address),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Go home button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text("Back to Home", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: primaryBlue, size: 14),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}