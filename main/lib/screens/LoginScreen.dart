import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/pages/home.dart';
import 'package:main/screens/Signup.dart';
import 'package:main/screens/forgotPassword.dart';
import '../util/AppDialog.dart';

const Color primaryBlue = Color(0xFF2D81FF);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool hiddePass = true;
  bool isLoading = false;

  Future<void> login() async {
    if (email.text == "" || password.text == "") {
      AppDialogs.showErrorDialog(context, 'Error', 'All Fields Are Required');
      return;
    }
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      setState(() => isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      String message = 'An error occurred';
      if (e.code == 'user-not-found') message = 'No account found with this email';
      if (e.code == 'wrong-password') message = 'Wrong password';
      if (e.code == 'invalid-email') message = 'Invalid email address';
      if (e.code == 'invalid-credential') message = 'Invalid email or password';
      AppDialogs.showErrorDialog(context, 'Error', message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/hieroglyphics.png'),
          fit: BoxFit.fill,
          opacity: 0.1,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Row(
                  children: [
                    Container(
                    padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryBlue, width: 2),
                ),
                child: Icon(Icons.medical_services, color: primaryBlue, size: 36),
              ),
                    SizedBox(width: 8),
                    Text("Tabibak", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryBlue)),
                  ],
                ),
                SizedBox(height: 40),
                Text("Login to Your Account", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 30),
                Text("Email", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                SizedBox(height: 8),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryBlue, width: 2)),
                  ),
                ),
                SizedBox(height: 20),
                Text("Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                SizedBox(height: 8),
                TextField(
                  controller: password,
                  obscureText: hiddePass,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryBlue, width: 2)),
                    suffixIcon: IconButton(
                      icon: Icon(hiddePass ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setState(() => hiddePass = !hiddePass),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword())),
                    child: Text("Forgot Password?", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.w500)),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Login", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => Signup())),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}