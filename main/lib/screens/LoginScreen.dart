import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main/pages/home.dart';
import 'package:main/screens/Signup.dart';
import 'package:main/screens/forgotPassword.dart';
import '../util/AppDialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Login Page"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 130, height: 130,
                child: Image.asset('assets/app_icon.png'),
              ),
              SizedBox(height: 15),
              Text("Welcome Back!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Text("Use Credentials to access your account", style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 15),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: password,
                obscureText: hiddePass,
                decoration: InputDecoration(
                  labelText: "Enter Your Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: TextButton(
                    child: Icon(hiddePass ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => hiddePass = !hiddePass),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword())),
                    child: Text("Forgot Password?", style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 18)),
                  )
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Log in", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Signup",
                        style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
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
    );
  }
}