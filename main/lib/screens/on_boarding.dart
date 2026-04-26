import 'package:flutter/material.dart';
import 'package:main/screens/LoginScreen.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> slides = [
    {
      'image': 'assets/main_splash_1.png',
      'title': 'Best Doctors in Egypt',
      'subtitle': 'Find and book top-rated doctors across Egypt in minutes',
    },
    {
      'image': 'assets/main_splash_2.png',
      'title': 'Book Your Appointment',
      'subtitle': "Schedule face-to-face appointments with Egypt's finest specialists",
    },
    {
      'image': 'assets/main_splash_3.png',
      'title': 'Your Health, Our Priority',
      'subtitle': "Tabiby is Egypt's #1 doctor appointment app",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  // Top image section
                  Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Stack(
                          children: [
                            // Doctor image
                            Positioned.fill(
                              child: Image.asset(
                                slides[index]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Blue gradient overlay at bottom of image
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 120,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      primaryBlue,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bottom blue section
                      Expanded(
                        flex: 4,
                        child: Container(color: primaryBlue),
                      ),
                    ],
                  ),

                  // Text content on top of blue section
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: size.height * 0.42,
                    child: Container(
                      color: primaryBlue,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slides[index]['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            slides[index]['subtitle']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 40),
                          // Dots indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(slides.length, (i) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: currentPage == i ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentPage == i ? Colors.white : Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 30),
                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () {
                                if (currentPage == slides.length - 1) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => LoginScreen()),
                                  );
                                } else {
                                  _controller.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                currentPage == slides.length - 1 ? "Get Started" : "Next",
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Skip button
                  Positioned(
                    top: 50,
                    right: 20,
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      ),
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}