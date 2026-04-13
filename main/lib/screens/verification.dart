import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main/screens/newPassword.dart';
import 'package:main/util/AppDialog.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _Verification();
}

class _Verification extends State<Verification> {
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());

  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String getVerificationCode() {
    return controllers.map((controller) => controller.text).join();
  }

  bool isVerificationCodeComplete() {
    return controllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Verification Screen"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter Verification Code", style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 15,),
              Center(
                child: Text("We have sent the verification code to your email", style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 45,
                    height: 55,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: controllers[index],
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        }
                        if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(
                child: Image.asset("assets/verify.png"),
                width: double.infinity,
                height: 400,
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
                  onPressed: () {
                    if (!isVerificationCodeComplete()) {
                      AppDialogs.showErrorDialog(
                          context,
                          "Error",
                          "Please enter the complete 6-digit verification code"
                      );
                    } else {
                      String verificationCode = getVerificationCode();
                      print("Verification Code: $verificationCode");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPassword()),
                      );
                    }
                  },
                  child: Text("Continue", style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}