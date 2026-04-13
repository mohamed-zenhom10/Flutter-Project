import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main/util/AppDialog.dart';

class NewPassword extends StatefulWidget {
  @override
  State<NewPassword> createState() => _NewPassword();
}

class _NewPassword extends State<NewPassword> {

  TextEditingController newPass = TextEditingController();
  TextEditingController confirmNewPass = TextEditingController();
  bool hiddeNewPass = true;
  bool hiddeConfirmNewPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("New Password Screen"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter New Password" , style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 15,),
              Text("Please enter you new password" , style: TextStyle(
                  fontSize: 17
              ),),
              SizedBox(height: 20,),
              TextField(
                controller: newPass,
                obscureText: hiddeNewPass,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: TextButton(
                    onPressed: (){
                      setState(() => hiddeNewPass = !hiddeNewPass);
                    },
                    child: Icon(hiddeNewPass ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: confirmNewPass,
                obscureText: hiddeConfirmNewPass,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: TextButton(
                    onPressed: (){
                      setState(() => hiddeConfirmNewPass = !hiddeConfirmNewPass);
                    },
                    child: Icon(hiddeConfirmNewPass ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
              SizedBox(
                child: Image.asset("assets/new_password.jpg"),
                width: double.infinity,
                height: 300,
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
                    if(newPass.text == "" || confirmNewPass.text == "") {
                      AppDialogs.showErrorDialog(context, "Error", "All Fields are Required");
                    }
                  },
                  child: Text("Continue" , style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}