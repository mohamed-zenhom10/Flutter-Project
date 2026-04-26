import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/util/doctor.dart';
import 'package:main/pages/doctor_profile.dart';
import 'package:main/pages/book_appointment.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Doctor> allDoctors = [];
  List<Doctor> filteredDoctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllDoctors();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAllDoctors() async {
    final snapshot = await FirebaseFirestore.instance.collection('doctors').get();
    setState(() {
      allDoctors = snapshot.docs.map((doc) {
        return Doctor.fromFirestore(doc.data(), doc.id);
      }).toList();
      filteredDoctors = [];
      isLoading = false;
    });
  }

  void onSearchChanged() {
    final query = searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() => filteredDoctors = []);
      return;
    }
    setState(() {
      filteredDoctors = allDoctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query) ||
            doctor.specialization.toLowerCase().contains(query) ||
            doctor.hospital.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Column(
        children: [
          // Blue header with search bar
          Container(
            padding: EdgeInsets.fromLTRB(16, 55, 16, 20),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: TextField(
                          controller: searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: "Search doctor, specialty...",
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey),
                              onPressed: () => searchController.clear(),
                            )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Text(
                  searchController.text.isEmpty
                      ? "Search from ${allDoctors.length} doctors"
                      : "${filteredDoctors.length} results found",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Results
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryBlue))
                : searchController.text.isEmpty
                ? _buildEmptyState()
                : filteredDoctors.isEmpty
                ? _buildNoResults()
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorProfile(doctor: doctor)),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, spreadRadius: 2)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryBlue.withOpacity(0.2), width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(doctor.image),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _highlightText(doctor.name, searchController.text),
                              SizedBox(height: 3),
                              Text(doctor.specialization, style: TextStyle(color: primaryBlue, fontSize: 13, fontWeight: FontWeight.w500)),
                              Text(doctor.hospital, style: TextStyle(color: Colors.grey, fontSize: 12)),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 14),
                                  Text(' ${doctor.rate}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  SizedBox(width: 8),
                                  Icon(Icons.work_outline, color: Colors.grey, size: 13),
                                  Text(' ${doctor.experience} yrs', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookAppointment(doctor: doctor)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            elevation: 0,
                          ),
                          child: Text("Book", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlightText(String text, String query) {
    if (query.isEmpty) return Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15));
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);
    if (index == -1) return Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15));

    return RichText(
      text: TextSpan(
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(color: primaryBlue, backgroundColor: primaryBlue.withOpacity(0.1)),
          ),
          TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(color: primaryBlue.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.search, size: 60, color: primaryBlue),
          ),
          SizedBox(height: 20),
          Text("Search for a Doctor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 8),
          Text("Search by name, specialty or hospital", style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: Icon(Icons.search_off, size: 60, color: Colors.grey),
          ),
          SizedBox(height: 20),
          Text("No doctors found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 8),
          Text("Try searching with a different name", style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}