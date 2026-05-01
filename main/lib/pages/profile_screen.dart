import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/screens/LoginScreen.dart';
import 'package:main/pages/my_appointments.dart';
import 'package:flutter/services.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String username = '';
  String email = '';
  String age = '';
  String gender = '';
  String medicalHistory = '';
  String selectedAvatar = '';
  bool isEditing = false;
  bool isLoading = true;

  final ageController = TextEditingController();
  final medicalHistoryController = TextEditingController();
  String selectedGender = 'Not specified';

  final List<String> genders = ['Not specified', 'Male', 'Female'];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          username = data['username'] ?? '';
          email = data['email'] ?? '';
          age = data['age'] ?? '';
          gender = data['gender'] ?? 'Not specified';
          selectedAvatar = data['avatar'] ?? '';
          medicalHistory = data['medicalHistory'] ?? '';
          ageController.text = age;
          medicalHistoryController.text = medicalHistory;
          selectedGender = gender.isEmpty ? 'Not specified' : gender;
          isLoading = false;
        });
      } else {
        // Document doesn't exist, create it
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'username': user!.email?.split('@')[0] ?? 'User',
          'email': user!.email ?? '',
          'age': '',
          'gender': 'Not specified',
          'medicalHistory': '',
          'createdAt': Timestamp.now(),

        });
        setState(() {
          username = user!.email?.split('@')[0] ?? 'User';
          email = user!.email ?? '';
          selectedGender = 'Not specified';
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveProfile() async {
    if (ageController.text.isNotEmpty && int.parse(ageController.text) > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid age!"), backgroundColor: Colors.red),
      );
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'age': ageController.text.trim(),
      'gender': selectedGender,
      'medicalHistory': medicalHistoryController.text.trim(),
      'avatar': selectedAvatar,
    });
    setState(() {
      age = ageController.text.trim();
      gender = selectedGender;
      medicalHistory = medicalHistoryController.text.trim();
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated!"), backgroundColor: Colors.green),
    );
    if (ageController.text.isNotEmpty && int.parse(ageController.text) > 120) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid age"), backgroundColor: Colors.red),
      );
      return;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  void showAvatarPicker() {
    final List<String> avatars = List.generate(12, (index) =>
    'https://api.dicebear.com/7.x/avataaars/png?seed=$index&backgroundColor=b6e3f4,c0aede,d1d4f9'
    );

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            SizedBox(height: 16),
            Text("Choose Avatar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                final isSelected = selectedAvatar == avatars[index];
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedAvatar = avatars[index]);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? primaryBlue : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatars[index]),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryBlue))
          : Column(
        children: [
          // Blue header
          Container(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
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
                      child: Text("My Profile", textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.white),
                      onPressed: () {
                        if (isEditing) {
                          saveProfile();
                        } else {
                          setState(() => isEditing = true);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Avatar
                GestureDetector(
                  onTap: isEditing ? showAvatarPicker : null,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        backgroundImage: selectedAvatar.isNotEmpty
                            ? NetworkImage(selectedAvatar)
                            : null,
                        child: selectedAvatar.isEmpty
                            ? Icon(Icons.person, color: Colors.white, size: 45)
                            : null,
                      ),
                      if (isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.edit, color: primaryBlue, size: 16),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(username, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(email, style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info
                  Text("Personal Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 12),

                  // Age
                  _buildCard(
                    child: isEditing
                        ? TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                        labelText: "Age",
                        prefixIcon: Icon(Icons.cake, color: primaryBlue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                      ),
                    )
                        : _infoRow(Icons.cake, "Age", age.isEmpty ? "Not set" : "$age years"),
                  ),
                  SizedBox(height: 10),

                  // Gender
                  _buildCard(
                    child: isEditing
                        ? DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        labelText: "Gender",
                        prefixIcon: Icon(Icons.person_outline, color: primaryBlue),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryBlue, width: 2)),
                      ),
                      items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (val) => setState(() => selectedGender = val!),
                    )
                        : _infoRow(Icons.person_outline, "Gender", gender.isEmpty ? "Not set" : gender),
                  ),
                  SizedBox(height: 20),

                  // Medical History
                  Text("Medical History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 12),
                  _buildCard(
                    child: isEditing
                        ? TextField(
                      controller: medicalHistoryController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Medical History",
                        hintText: "e.g. Diabetes, Hypertension, Allergies...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryBlue, width: 2)),
                      ),
                    )
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Icon(Icons.medical_information, color: primaryBlue, size: 18),
                            ),
                            SizedBox(width: 12),
                            Text("Medical History", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          medicalHistory.isEmpty ? "No medical history added yet" : medicalHistory,
                          style: TextStyle(fontSize: 14, color: medicalHistory.isEmpty ? Colors.grey : Colors.black87, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // My Appointments button
                  Text("Quick Actions", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 12),
                  _buildCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.calendar_month, color: primaryBlue, size: 20),
                      ),
                      title: Text("My Appointments", style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text("View all your appointments", style: TextStyle(fontSize: 12)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppointments())),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Sign out button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: signOut,
                      icon: Icon(Icons.logout, color: Colors.red),
                      label: Text("Sign Out", style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
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

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 5, spreadRadius: 1)],
      ),
      child: child,
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: primaryBlue, size: 18),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}