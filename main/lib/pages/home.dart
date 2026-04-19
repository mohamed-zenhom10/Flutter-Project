import 'package:flutter/material.dart';
import 'package:main/pages/popular_doctors.dart';
import 'package:main/util/doctor.dart';
import 'package:main/widgets/doctor_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState () => _HomePage();
}

class _HomePage extends State<HomePage> {

  TextEditingController searchValue = TextEditingController();

  final List<Doctor> allDoctors = const [
    Doctor(name: "Dr. Sarah", image: "assets/user_img.png", rate: 4.9, specialization: "Heart"),
    Doctor(name: "Dr. Michael", image: "assets/user_img.png", rate: 4.8, specialization: "Heart"),
    Doctor(name: "Dr. Emily", image: "assets/user_img.png", rate: 4.7, specialization: "Heart"),
    Doctor(name: "Dr. James", image: "assets/user_img.png", rate: 4.6, specialization: "Heart"),
    Doctor(name: "Dr. Lisa", image: "assets/user_img.png", rate: 4.5, specialization: "Heart"),
    Doctor(name: "Dr. Robert", image: "assets/user_img.png", rate: 4.4, specialization: "Heart"),
    Doctor(name: "Dr. Maria", image: "assets/user_img.png", rate: 4.3, specialization: "Heart"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Home Page"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Username" , style: TextStyle(
                    fontSize: 22,
                  ),),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset("assets/user_img.png"),
                  )
                ],
              ),
              SizedBox(height: 15,),
              Text("Keep taking care of your health" , style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 15,),
              TextField(
                controller: searchValue,
                decoration: InputDecoration(
                  labelText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Popular Doctors" , style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder:(context) => PopularDoctors())
                      );
                    },
                    child: Text("See all", style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 18
                    ),),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              DoctorCarousel(allDoctors: allDoctors),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(items: items),
    );
  }
}