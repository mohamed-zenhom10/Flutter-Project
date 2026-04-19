import 'package:flutter/material.dart';

class PopularDoctors extends StatefulWidget {
  const PopularDoctors({super.key});

  @override
  State<PopularDoctors> createState() => _PopularDoctors();
}

class _PopularDoctors extends State<PopularDoctors> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Popular Doctors"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ],
          ),
        ),
      ),
    );
  }
}