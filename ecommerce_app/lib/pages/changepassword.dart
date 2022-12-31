// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  final int userid;
  final String email;

  const ChangePasswordPage(
      {super.key, required this.userid, required this.email});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  CollectionReference users =
      FirebaseFirestore.instance.collection("UserDetails");
  TextEditingController oldpassword = TextEditingController();
  TextEditingController changepassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  bool _isHidden = true;
  bool _isHidden2 = true;
  String oldpass = "";
  String userkey = "";
  getauthentication(String old) async {
    await users
        .where("id", isEqualTo: widget.userid)
        .where("user_email", isEqualTo: widget.email)
        .get()
        .then((value) {
      for (var element in value.docs) {
        oldpass = element['user_password'];
        userkey = element.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 50, left: 0)),
            Align(
              child: Text(
                "Change Password",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 50, left: 0)),
            SizedBox(
              width: 300,
              child: TextField(
                controller: oldpassword,
                decoration: const InputDecoration(
                    hintText: "Enter your Old Password ",
                    labelText: "Old Password",
                    fillColor: Colors.yellow,
                    icon: Icon(Icons.person),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white))),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10, left: 0)),
            SizedBox(
              width: 300,
              child: TextField(
                controller: changepassword,
                obscureText: _isHidden,
                decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    hintText: "Enter your New Password",
                    labelText: "New Password",
                    fillColor: Colors.yellow,
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                      child: Icon(
                        _isHidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white))),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10, left: 0)),
            SizedBox(
              width: 300,
              child: TextField(
                controller: confirmpassword,
                obscureText: _isHidden2,
                decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    hintText: "Enter your Confirm Password",
                    labelText: "Confirm Password",
                    fillColor: Colors.yellow,
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          _isHidden2 = !_isHidden2;
                        });
                      },
                      child: Icon(
                        _isHidden2 ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white))),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10, left: 0)),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () async {
                    await getauthentication(oldpassword.text);
                    if (oldpass == oldpassword.text) {
                      if (changepassword.text == confirmpassword.text) {
                        await users.doc(userkey).update({
                          "user_password": confirmpassword.text,
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Password has been Changed"),
                        ));
                      }
                      else{
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Password and Confirm password didn't Match"),
                        ));
                      }
                    }
                    else
                    {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Old password in incorrect"),
                        ));
                    }
                    oldpassword.clear();
                    confirmpassword.clear();
                    changepassword.clear();
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(width: 0.5, color: Colors.white),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("Change Password")),
            )
          ],
        ),
      )),
    );
  }
}
