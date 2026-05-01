import 'package:flutter/material.dart';
import 'package:main/util/doctor.dart';
import 'package:main/pages/book_appointment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:main/widgets/doctor_carousel.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class DoctorProfile extends StatelessWidget {
  final Doctor doctor;

  const DoctorProfile({super.key, required this.doctor});

  Future<void> openMaps() async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${doctor.latitude},${doctor.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Header with doctor image
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.08),
            ),
            child: Stack(
              children: [
                // Back button
                Positioned(
                  top: 50,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade200, blurRadius: 5)
                        ],
                      ),
                      child: Icon(Icons.arrow_back_ios,
                          color: primaryBlue, size: 18),
                    ),
                  ),
                ),

                // Doctor info on left
                Positioned(
                  top: 80,
                  left: 20,
                  right: 190,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          doctor.specialization,
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        doctor.hospital,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'EGP ${doctor.fee} / session',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Doctor image on right
                Positioned(
                  right: 0,
                  bottom: 0,
                  top: 30,
                  child: doctorAvatar(doctor.name, 80),
                ),
              ],
            ),
          ),

          // Stats row
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            transform: Matrix4.translationValues(0, -20, 0),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statCard(Icons.people, '1000+', 'Patients',
                    Colors.blue.shade50, primaryBlue),
                _divider(),
                _statCard(Icons.work_outline,
                    '${doctor.experience} yrs', 'Experience',
                    Colors.orange.shade50, Colors.orange),
                _divider(),
                _statCard(Icons.star, '${doctor.rate}', 'Rating',
                    Colors.amber.shade50, Colors.amber),
              ],
            ),
          ),

          // About section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About Doctor",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 10),
                  Text(
                    "Dr. ${doctor.name.replaceAll('Dr. ', '')} is a highly experienced ${doctor.specialization} specialist at ${doctor.hospital}. "
                        "With ${doctor.experience} years of expertise, they are dedicated to providing the best medical care to patients across Egypt. "
                        "Rated ${doctor.rate} by over 1000 patients, they are among Egypt's top medical professionals.",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.6),
                  ),
                  SizedBox(height: 20),

                  Text("Information",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 12),

                  _infoCard(Icons.local_hospital, "Hospital", doctor.hospital),
                  SizedBox(height: 10),
                  _infoCard(Icons.medical_services, "Specialty",
                      doctor.specialization),
                  SizedBox(height: 10),
                  _infoCard(Icons.work_outline, "Experience",
                      "${doctor.experience} years"),
                  SizedBox(height: 10),
                  _infoCard(Icons.star, "Rating",
                      "${doctor.rate} / 5.0"),
                  SizedBox(height: 10),
                  _infoCard(Icons.payments, "Consultation Fee",
                      "EGP ${doctor.fee}"),
                  SizedBox(height: 10),

                  // Location card
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.location_on,
                              color: primaryBlue, size: 18),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text("Location",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              Text(
                                doctor.address,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: openMaps,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.map,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text("Maps",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Book button
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: Offset(0, -3))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookAppointment(doctor: doctor),
                  ),
                ),
                icon: Icon(Icons.calendar_today,
                    color: Colors.white, size: 18),
                label: Text(
                  "Book Appointment",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label,
      Color bgColor, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration:
          BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        SizedBox(height: 6),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87)),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 50, color: Colors.grey.shade200);
  }

  Widget _infoCard(
      IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 5,
              spreadRadius: 1)
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryBlue, size: 18),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey)),
              Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }
}