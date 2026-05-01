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
      {'name': 'Dr. Sarah Ahmed', 'specialization': 'Cardiology', 'rate': 4.9, 'experience': 12, 'hospital': 'Cairo Heart Center', 'image': 'assets/user_img.png', 'fee': 350, 'address': 'Cairo Heart Center, Nasr City, Cairo', 'latitude': 30.0626, 'longitude': 31.3361},
      {'name': 'Dr. Michael Hassan', 'specialization': 'Cardiology', 'rate': 4.8, 'experience': 10, 'hospital': 'Nile Medical Center', 'image': 'assets/user_img.png', 'fee': 300, 'address': 'Nile Medical Center, Dokki, Giza', 'latitude': 30.0393, 'longitude': 31.2117},
      {'name': 'Dr. Amira Saleh', 'specialization': 'Cardiology', 'rate': 4.7, 'experience': 9, 'hospital': 'Al Nozha Hospital', 'image': 'assets/user_img.png', 'fee': 250, 'address': 'Al Nozha Hospital, Heliopolis, Cairo', 'latitude': 30.0936, 'longitude': 31.3412},
      {'name': 'Dr. Khaled Mostafa', 'specialization': 'Cardiology', 'rate': 4.6, 'experience': 14, 'hospital': 'Ain Shams Hospital', 'image': 'assets/user_img.png', 'fee': 400, 'address': 'Ain Shams University Hospital, Abbassia, Cairo', 'latitude': 30.0731, 'longitude': 31.2797},
      {'name': 'Dr. Rania Fouad', 'specialization': 'Cardiology', 'rate': 4.5, 'experience': 8, 'hospital': 'Cairo Heart Center', 'image': 'assets/user_img.png', 'fee': 300, 'address': 'Cairo Heart Center, Nasr City, Cairo', 'latitude': 30.0626, 'longitude': 31.3361},
      // Neurology
      {'name': 'Dr. Emily Nour', 'specialization': 'Neurology', 'rate': 4.7, 'experience': 8, 'hospital': 'Cairo University Hospital', 'image': 'assets/user_img.png', 'fee': 350, 'address': 'Cairo University Hospital, Kasr Al Ainy, Cairo', 'latitude': 30.0282, 'longitude': 31.2297},
      {'name': 'Dr. James Khalil', 'specialization': 'Neurology', 'rate': 4.6, 'experience': 15, 'hospital': 'Al Salam Hospital', 'image': 'assets/user_img.png', 'fee': 450, 'address': 'Al Salam Hospital, Mohandessin, Giza', 'latitude': 30.0561, 'longitude': 31.1996},
      {'name': 'Dr. Mona Gamal', 'specialization': 'Neurology', 'rate': 4.8, 'experience': 11, 'hospital': 'Nile Medical Center', 'image': 'assets/user_img.png', 'fee': 380, 'address': 'Nile Medical Center, Dokki, Giza', 'latitude': 30.0393, 'longitude': 31.2117},
      {'name': 'Dr. Tarek Samir', 'specialization': 'Neurology', 'rate': 4.5, 'experience': 7, 'hospital': 'Al Salam Hospital', 'image': 'assets/user_img.png', 'fee': 300, 'address': 'Al Salam Hospital, Mohandessin, Giza', 'latitude': 30.0561, 'longitude': 31.1996},
      {'name': 'Dr. Heba Lotfy', 'specialization': 'Neurology', 'rate': 4.4, 'experience': 6, 'hospital': 'Cairo University Hospital', 'image': 'assets/user_img.png', 'fee': 250, 'address': 'Cairo University Hospital, Kasr Al Ainy, Cairo', 'latitude': 30.0282, 'longitude': 31.2297},
      // Dermatology
      {'name': 'Dr. Lisa Mahmoud', 'specialization': 'Dermatology', 'rate': 4.5, 'experience': 6, 'hospital': 'Skin Care Clinic', 'image': 'assets/user_img.png', 'fee': 200, 'address': 'Skin Care Clinic, Zamalek, Cairo', 'latitude': 30.0626, 'longitude': 31.2192},
      {'name': 'Dr. Omar Farouk', 'specialization': 'Dermatology', 'rate': 4.4, 'experience': 9, 'hospital': 'Cairo Derma Center', 'image': 'assets/user_img.png', 'fee': 250, 'address': 'Cairo Derma Center, Heliopolis, Cairo', 'latitude': 30.0936, 'longitude': 31.3412},
      {'name': 'Dr. Yasmin Adel', 'specialization': 'Dermatology', 'rate': 4.7, 'experience': 10, 'hospital': 'Skin Care Clinic', 'image': 'assets/user_img.png', 'fee': 300, 'address': 'Skin Care Clinic, Zamalek, Cairo', 'latitude': 30.0626, 'longitude': 31.2192},
      {'name': 'Dr. Sherif Nabil', 'specialization': 'Dermatology', 'rate': 4.3, 'experience': 5, 'hospital': 'Cairo Derma Center', 'image': 'assets/user_img.png', 'fee': 180, 'address': 'Cairo Derma Center, Heliopolis, Cairo', 'latitude': 30.0936, 'longitude': 31.3412},
      {'name': 'Dr. Dina Wael', 'specialization': 'Dermatology', 'rate': 4.6, 'experience': 8, 'hospital': 'Al Nozha Hospital', 'image': 'assets/user_img.png', 'fee': 220, 'address': 'Al Nozha Hospital, Heliopolis, Cairo', 'latitude': 30.0936, 'longitude': 31.3412},
      // Orthopedics
      {'name': 'Dr. Maria Youssef', 'specialization': 'Orthopedics', 'rate': 4.8, 'experience': 11, 'hospital': 'Bone & Joint Hospital', 'image': 'assets/user_img.png', 'fee': 400, 'address': 'Bone & Joint Hospital, New Cairo, Cairo', 'latitude': 30.0131, 'longitude': 31.4961},
      {'name': 'Dr. Ahmed Samy', 'specialization': 'Orthopedics', 'rate': 4.3, 'experience': 7, 'hospital': 'Cairo Medical Center', 'image': 'assets/user_img.png', 'fee': 280, 'address': 'Cairo Medical Center, Maadi, Cairo', 'latitude': 29.9602, 'longitude': 31.2569},
      {'name': 'Dr. Mahmoud Fathy', 'specialization': 'Orthopedics', 'rate': 4.6, 'experience': 13, 'hospital': 'Bone & Joint Hospital', 'image': 'assets/user_img.png', 'fee': 350, 'address': 'Bone & Joint Hospital, New Cairo, Cairo', 'latitude': 30.0131, 'longitude': 31.4961},
      {'name': 'Dr. Noha Ramzy', 'specialization': 'Orthopedics', 'rate': 4.5, 'experience': 9, 'hospital': 'Ain Shams Hospital', 'image': 'assets/user_img.png', 'fee': 300, 'address': 'Ain Shams University Hospital, Abbassia, Cairo', 'latitude': 30.0731, 'longitude': 31.2797},
      {'name': 'Dr. Wael Ibrahim', 'specialization': 'Orthopedics', 'rate': 4.4, 'experience': 6, 'hospital': 'Cairo Medical Center', 'image': 'assets/user_img.png', 'fee': 250, 'address': 'Cairo Medical Center, Maadi, Cairo', 'latitude': 29.9602, 'longitude': 31.2569},
      // Pediatrics
      {'name': 'Dr. Nadia Tarek', 'specialization': 'Pediatrics', 'rate': 4.9, 'experience': 13, 'hospital': 'Children\'s Hospital', 'image': 'assets/user_img.png', 'fee': 300, 'address': 'Cairo Children\'s Hospital, Abbassia, Cairo', 'latitude': 30.0731, 'longitude': 31.2797},
      {'name': 'Dr. Karim Adel', 'specialization': 'Pediatrics', 'rate': 4.7, 'experience': 8, 'hospital': 'Nile Children Center', 'image': 'assets/user_img.png', 'fee': 250, 'address': 'Nile Children Center, Agouza, Giza', 'latitude': 30.0561, 'longitude': 31.2117},
      {'name': 'Dr. Salma Hesham', 'specialization': 'Pediatrics', 'rate': 4.8, 'experience': 10, 'hospital': 'Children\'s Hospital', 'image': 'assets/user_img.png', 'fee': 280, 'address': 'Cairo Children\'s Hospital, Abbassia, Cairo', 'latitude': 30.0731, 'longitude': 31.2797},
      {'name': 'Dr. Amir Zaki', 'specialization': 'Pediatrics', 'rate': 4.6, 'experience': 7, 'hospital': 'Nile Children Center', 'image': 'assets/user_img.png', 'fee': 220, 'address': 'Nile Children Center, Agouza, Giza', 'latitude': 30.0561, 'longitude': 31.2117},
      {'name': 'Dr. Rana Medhat', 'specialization': 'Pediatrics', 'rate': 4.5, 'experience': 5, 'hospital': 'Al Salam Hospital', 'image': 'assets/user_img.png', 'fee': 200, 'address': 'Al Salam Hospital, Mohandessin, Giza', 'latitude': 30.0561, 'longitude': 31.1996},
      // Ophthalmology
      {'name': 'Dr. Hany Magdy', 'specialization': 'Ophthalmology', 'rate': 4.9, 'experience': 15, 'hospital': 'Eye Care Center', 'image': 'assets/user_img.png', 'fee': 400, 'address': 'Eye Care Center, Mohandessin, Giza', 'latitude': 30.0561, 'longitude': 31.1996},
      {'name': 'Dr. Mariam Essam', 'specialization': 'Ophthalmology', 'rate': 4.7, 'experience': 9, 'hospital': 'Cairo Eye Hospital', 'image': 'assets/user_img.png', 'fee': 300, 'address': 'Cairo Eye Hospital, Nasr City, Cairo', 'latitude': 30.0626, 'longitude': 31.3361},
      {'name': 'Dr. Bassem Nader', 'specialization': 'Ophthalmology', 'rate': 4.6, 'experience': 11, 'hospital': 'Eye Care Center', 'image': 'assets/user_img.png', 'fee': 350, 'address': 'Eye Care Center, Mohandessin, Giza', 'latitude': 30.0561, 'longitude': 31.1996},
      {'name': 'Dr. Ghada Saad', 'specialization': 'Ophthalmology', 'rate': 4.5, 'experience': 8, 'hospital': 'Cairo Eye Hospital', 'image': 'assets/user_img.png', 'fee': 280, 'address': 'Cairo Eye Hospital, Nasr City, Cairo', 'latitude': 30.0626, 'longitude': 31.3361},
      {'name': 'Dr. Fady Naguib', 'specialization': 'Ophthalmology', 'rate': 4.4, 'experience': 6, 'hospital': 'Nile Medical Center', 'image': 'assets/user_img.png', 'fee': 250, 'address': 'Nile Medical Center, Dokki, Giza', 'latitude': 30.0393, 'longitude': 31.2117},
    ];

    for (var doctor in doctors) {
      await firestore.collection('doctors').add(doctor);
    }

    print('30 Doctors seeded successfully with fees and locations!');
  }
}