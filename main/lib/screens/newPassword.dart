import 'package:flutter/material.dart';
import 'package:main/util/AppDialog.dart';
import 'package:main/screens/LoginScreen.dart';

const Color primaryBlue = Color(0xFF2D81FF);

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
                Text("Create New Password", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 10),
                Text(
                  "Your new password must be different from your previous password.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                ),
                SizedBox(height: 40),
                // Icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lock_open, size: 50, color: primaryBlue),
                  ),
                ),
                SizedBox(height: 40),
                // New password
                Text("New Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                SizedBox(height: 8),
                TextField(
                  controller: newPass,
                  obscureText: hiddeNewPass,
                  decoration: InputDecoration(
                    hintText: "Enter new password",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    prefixIcon: Icon(Icons.lock, color: primaryBlue),
                    suffixIcon: IconButton(
                      icon: Icon(hiddeNewPass ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setState(() => hiddeNewPass = !hiddeNewPass),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryBlue, width: 2)),
                  ),
                ),
                SizedBox(height: 20),
                // Confirm password
                Text("Confirm Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                SizedBox(height: 8),
                TextField(
                  controller: confirmNewPass,
                  obscureText: hiddeConfirmNewPass,
                  decoration: InputDecoration(
                    hintText: "Confirm new password",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    prefixIcon: Icon(Icons.lock, color: primaryBlue),
                    suffixIcon: IconButton(
                      icon: Icon(hiddeConfirmNewPass ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setState(() => hiddeConfirmNewPass = !hiddeConfirmNewPass),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryBlue, width: 2)),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      if (newPass.text == "" || confirmNewPass.text == "") {
                        AppDialogs.showErrorDialog(context, "Error", "All Fields are Required");
                      } else if (newPass.text != confirmNewPass.text) {
                        AppDialogs.showErrorDialog(context, "Error", "Passwords do not match");
                      } else if (newPass.text.length < 6) {
                        AppDialogs.showErrorDialog(context, "Error", "Password must be at least 6 characters");
                      } else {
                        AppDialogs.showConfirmationDialog(
                          context,
                          "Success",
                          "Password changed successfully! Please login again.",
                              () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                (route) => false,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text("Save Password", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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