import 'package:flutter/material.dart';
import 'package:main/screens/verification.dart';
import 'package:main/util/AppDialog.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});


  @override
  State<ForgotPassword> createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Forgot Password Screen"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Forgot Password" , style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 15,),
              Center(

                child: Text("Select which contact details we use to reset your password.", style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30,),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Email or Phone Number",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                child: Image.asset("assets/app_icon.png"),
                width: 300,
                height: 300,
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (){
                    if(email.text == "") {
                      AppDialogs.showErrorDialog(context,"Error","The Email or Phone is Required");
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder:(context) => Verification()),
                      );
                    }
                  },
                  child: Text("Continue" , style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}