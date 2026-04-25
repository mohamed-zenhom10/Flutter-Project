import 'package:cloud_firestore/cloud_firestore.dart';

class SeedData {
  static Future<void> seedDoctors() async {
    final firestore = FirebaseFirestore.instance;

    // Delete existing doctors first to avoid duplicates
    final existing = await firestore.collection('doctors').get();
    for (var doc in existing.docs) {
      await doc.reference.delete();
    }

    final List<Map<String, dynamic>> doctors = [
      // Cardiology
      {'name': 'Dr. Sarah Ahmed', 'specialization': 'Cardiology', 'rate': 4.9, 'experience': 12, 'hospital': 'Cairo Heart Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Michael Hassan', 'specialization': 'Cardiology', 'rate': 4.8, 'experience': 10, 'hospital': 'Nile Medical Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Amira Saleh', 'specialization': 'Cardiology', 'rate': 4.7, 'experience': 9, 'hospital': 'Al Nozha Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Khaled Mostafa', 'specialization': 'Cardiology', 'rate': 4.6, 'experience': 14, 'hospital': 'Ain Shams Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Rania Fouad', 'specialization': 'Cardiology', 'rate': 4.5, 'experience': 8, 'hospital': 'Cairo Heart Center', 'image': 'assets/user_img.png'},
      // Neurology
      {'name': 'Dr. Emily Nour', 'specialization': 'Neurology', 'rate': 4.7, 'experience': 8, 'hospital': 'Cairo University Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. James Khalil', 'specialization': 'Neurology', 'rate': 4.6, 'experience': 15, 'hospital': 'Al Salam Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Mona Gamal', 'specialization': 'Neurology', 'rate': 4.8, 'experience': 11, 'hospital': 'Nile Medical Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Tarek Samir', 'specialization': 'Neurology', 'rate': 4.5, 'experience': 7, 'hospital': 'Al Salam Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Heba Lotfy', 'specialization': 'Neurology', 'rate': 4.4, 'experience': 6, 'hospital': 'Cairo University Hospital', 'image': 'assets/user_img.png'},
      // Dermatology
      {'name': 'Dr. Lisa Mahmoud', 'specialization': 'Dermatology', 'rate': 4.5, 'experience': 6, 'hospital': 'Skin Care Clinic', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Omar Farouk', 'specialization': 'Dermatology', 'rate': 4.4, 'experience': 9, 'hospital': 'Cairo Derma Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Yasmin Adel', 'specialization': 'Dermatology', 'rate': 4.7, 'experience': 10, 'hospital': 'Skin Care Clinic', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Sherif Nabil', 'specialization': 'Dermatology', 'rate': 4.3, 'experience': 5, 'hospital': 'Cairo Derma Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Dina Wael', 'specialization': 'Dermatology', 'rate': 4.6, 'experience': 8, 'hospital': 'Al Nozha Hospital', 'image': 'assets/user_img.png'},
      // Orthopedics
      {'name': 'Dr. Maria Youssef', 'specialization': 'Orthopedics', 'rate': 4.8, 'experience': 11, 'hospital': 'Bone & Joint Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Ahmed Samy', 'specialization': 'Orthopedics', 'rate': 4.3, 'experience': 7, 'hospital': 'Cairo Medical Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Mahmoud Fathy', 'specialization': 'Orthopedics', 'rate': 4.6, 'experience': 13, 'hospital': 'Bone & Joint Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Noha Ramzy', 'specialization': 'Orthopedics', 'rate': 4.5, 'experience': 9, 'hospital': 'Ain Shams Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Wael Ibrahim', 'specialization': 'Orthopedics', 'rate': 4.4, 'experience': 6, 'hospital': 'Cairo Medical Center', 'image': 'assets/user_img.png'},
      // Pediatrics
      {'name': 'Dr. Nadia Tarek', 'specialization': 'Pediatrics', 'rate': 4.9, 'experience': 13, 'hospital': 'Children\'s Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Karim Adel', 'specialization': 'Pediatrics', 'rate': 4.7, 'experience': 8, 'hospital': 'Nile Children Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Salma Hesham', 'specialization': 'Pediatrics', 'rate': 4.8, 'experience': 10, 'hospital': 'Children\'s Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Amir Zaki', 'specialization': 'Pediatrics', 'rate': 4.6, 'experience': 7, 'hospital': 'Nile Children Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Rana Medhat', 'specialization': 'Pediatrics', 'rate': 4.5, 'experience': 5, 'hospital': 'Al Salam Hospital', 'image': 'assets/user_img.png'},
      // Ophthalmology
      {'name': 'Dr. Hany Magdy', 'specialization': 'Ophthalmology', 'rate': 4.9, 'experience': 15, 'hospital': 'Eye Care Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Mariam Essam', 'specialization': 'Ophthalmology', 'rate': 4.7, 'experience': 9, 'hospital': 'Cairo Eye Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Bassem Nader', 'specialization': 'Ophthalmology', 'rate': 4.6, 'experience': 11, 'hospital': 'Eye Care Center', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Ghada Saad', 'specialization': 'Ophthalmology', 'rate': 4.5, 'experience': 8, 'hospital': 'Cairo Eye Hospital', 'image': 'assets/user_img.png'},
      {'name': 'Dr. Fady Naguib', 'specialization': 'Ophthalmology', 'rate': 4.4, 'experience': 6, 'hospital': 'Nile Medical Center', 'image': 'assets/user_img.png'},
    ];

    for (var doctor in doctors) {
      await firestore.collection('doctors').add(doctor);
    }

    print('30 Doctors seeded successfully!');
  }
}