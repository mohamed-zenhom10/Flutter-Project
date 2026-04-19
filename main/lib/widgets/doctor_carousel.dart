import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../util/doctor.dart';

class DoctorCarousel extends StatelessWidget {
  final List<Doctor> allDoctors;

  const DoctorCarousel({super.key, required this.allDoctors});

  @override
  Widget build(BuildContext context) {
    final topDoctors = List<Doctor>.from(allDoctors)
      ..sort((a, b) => b.rate.compareTo(a.rate));

    final top5Doctors = topDoctors.take(5).toList();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(height: 250, autoPlay: false),
          items: top5Doctors.map((doctor) => _buildDoctorCard(doctor)).toList(),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 45, backgroundImage: AssetImage(doctor.image)),
          const SizedBox(height: 10),
          Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(doctor.specialization, style: TextStyle(color: Colors.grey[600])),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(' ${doctor.rate}'),
            ],
          ),
        ],
      ),
    );
  }

  void _showAllDoctors(BuildContext context, List<Doctor> doctors) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        children: doctors.map((doctor) => ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(doctor.image)),
          title: Text(doctor.name),
          subtitle: Text(doctor.specialization),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            Text(' ${doctor.rate}'),
          ]),
        )).toList(),
      ),
    );
  }
}