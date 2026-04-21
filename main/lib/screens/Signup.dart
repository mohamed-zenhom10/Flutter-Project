import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/AppDialog.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool hiddePass = true;
  bool isLoading = false;

  Future<void> signUp() async {
    if (username.text == "" || email.text == "" || password.text == "") {
      AppDialogs.showErrorDialog(context, 'Error', 'All Fields Are Required');
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username.text.trim(),
        'email': email.text.trim(),
        'createdAt': Timestamp.now(),
      });

      setState(() => isLoading = false);
      AppDialogs.showErrorDialog(context, 'Success', 'Account created successfully!');

    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      String message = 'An error occurred';
      if (e.code == 'weak-password') message = 'Password is too weak';
      if (e.code == 'email-already-in-use') message = 'Email already in use';
      if (e.code == 'invalid-email') message = 'Invalid email address';
      AppDialogs.showErrorDialog(context, 'Error', message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Signup Page"),
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
              Text("Create an Account", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Text("Please fill this detail to create an account", style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 15),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Username",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
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
                    onPressed: () => setState(() => hiddePass = !hiddePass),
                    child: Icon(hiddePass ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Sign up", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context),
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