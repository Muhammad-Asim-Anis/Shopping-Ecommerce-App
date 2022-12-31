import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/pages/forgetpassword.dart';
import 'package:ecommerce_app/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController useremail = TextEditingController();
  TextEditingController pass = TextEditingController();
  String email = "";
  int count = 0;
  String username = "";
  String usercontact = "";
  int userid = 0;
  bool _isHidden = true;
  CollectionReference users =
      FirebaseFirestore.instance.collection("UserDetails");

  Future<int> getUserAuthenticate(String email, String pass) async {
    AggregateQuery count = users
        .where("user_email", isEqualTo: email)
        .where("user_password", isEqualTo: pass)
        .count();
    AggregateQuerySnapshot snap = await count.get();

    return snap.count;
  }

  getUserAuthenticatedetails(String email, String pass) async {
    QuerySnapshot detail = await users
        .where("user_email", isEqualTo: email)
        .where("user_password", isEqualTo: pass)
        .get();
    for (var element in detail.docs) {
      userid = element['id'];
      username = element['username'];
      usercontact = element['user_contact'];
    }
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 50, left: 0)),
              Align(
                child: Text(
                  "Sign in",
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
                  controller: useremail,
                  decoration: const InputDecoration(
                      hintText: "Enter your email",
                      labelText: "Email",
                      fillColor: Colors.yellow,
                      icon: Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.white))),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10, left: 0)),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: pass,
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: "Enter your Passsword",
                      labelText: "Password",
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
                      fillColor: Colors.yellow,
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.white))),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20, left: 0)),
              Align(
                alignment: Alignment.centerRight,
                widthFactor: 2.5,
                heightFactor: 2,
                child: InkWell(
                  child: const Text('Forget Password',
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.end),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgetPasswordPage()));
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () async {
                    await getUserAuthenticate(useremail.text, pass.text)
                        .then((value) => count = value);

                    if (count > 0) {
                      email = useremail.text;
                      await getUserAuthenticatedetails(
                          useremail.text, pass.text);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    email: email,
                                    name: username,
                                    status: true,
                                    usercontact: usercontact,
                                    userid: userid,
                                  )));
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Failed'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const [
                                  Text('First Registered Yourself'),
                                  Text(
                                      'Would you like to approve of this message?'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Approve'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    useremail.clear();
                    pass.clear();
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(width: 0.5, color: Colors.white),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("Sign in"),
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(width: 0.5, color: Colors.white),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("Sign Up"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
