import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:main/screens/Signup.dart';

import '../util/AppDialog.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState () => _Signup();
}

class _Signup extends State<Signup> {

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool hiddePass = true;

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
                child: Image.asset('assets/app_icon.png'),
                width: 130,
                height: 130,
              ),
              SizedBox(height: 15,),
              Text("Create an Account" , style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 15,),
              Text("Please fill this detail to create an account" , style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),),
              SizedBox(height: 15,),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Username",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: password,
                obscureText: hiddePass,
                decoration: InputDecoration(
                  labelText: "Enter Your Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() => hiddePass = !hiddePass);
                    },
                    child: Icon(hiddePass ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if(username.text == "" || email.text == "" || password.text == "") {
                      AppDialogs.showErrorDialog(context, 'Error', 'All Fields Are Required');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Sign up", style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "OR",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.network(
                    'https://www.google.com/favicon.ico',
                    width: 24,
                    height: 24,
                  ),
                  label: Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.network(
                    'https://www.facebook.com/favicon.ico',
                    width: 24,
                    height: 24,
                  ),
                  label: Text(
                    "Sign in with Facebook",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
