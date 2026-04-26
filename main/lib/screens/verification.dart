import 'package:flutter/material.dart';
import 'package:main/screens/newPassword.dart';
import 'package:main/util/AppDialog.dart';

const Color primaryBlue = Color(0xFF2D81FF);

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
    for (var controller in controllers) controller.dispose();
    for (var focusNode in focusNodes) focusNode.dispose();
    super.dispose();
  }

  String getVerificationCode() => controllers.map((c) => c.text).join();
  bool isVerificationCodeComplete() => controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/hieroglyphics.png'),
          fit: BoxFit.fill,
          opacity: 0.15,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: primaryBlue),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Logo
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
                Text("Verification Code", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 10),
                Text(
                  "We sent a verification code to your email. Please enter it below.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                ),
                SizedBox(height: 40),
                // Lock icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mark_email_read, size: 50, color: primaryBlue),
                  ),
                ),
                SizedBox(height: 40),
                // OTP fields
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
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryBlue),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryBlue, width: 2),
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
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isVerificationCodeComplete()) {
                        AppDialogs.showErrorDialog(context, "Error", "Please enter the complete 6-digit code");
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewPassword()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text("Continue", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: RichText(
                      text: TextSpan(
                        text: "Didn't receive the code? ",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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