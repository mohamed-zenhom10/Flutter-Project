class Doctor {
  final String id;
  final String name;
  final String image;
  final double rate;
  final String specialization;
  final int experience;
  final String hospital;
  final int fee;
  final String address;
  final double latitude;
  final double longitude;

  const Doctor({
    required this.id,
    required this.name,
    required this.image,
    required this.rate,
    required this.specialization,
    required this.experience,
    required this.hospital,
    required this.fee,
    required this.address,
    required this.latitude,
    required this.longitude,
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
      fee: (data['fee'] ?? 0).toInt(),
      address: data['address'] ?? '',
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }
}