class Doctor {
  final String id;
  final String name;
  final String image;
  final double rate;
  final String specialization;
  final int experience;
  final String hospital;

  const Doctor({
    required this.id,
    required this.name,
    required this.image,
    required this.rate,
    required this.specialization,
    required this.experience,
    required this.hospital,
  });

  factory Doctor.fromFirestore(Map<String, dynamic> data, String id) {
    return Doctor(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? 'assets/user_img.png',
      rate: (data['rate'] ?? 0).toDouble(),
      specialization: data['specialization'] ?? '',
      experience: data['experience'] ?? 0,
      hospital: data['hospital'] ?? '',
    );
  }
}