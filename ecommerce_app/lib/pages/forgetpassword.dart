import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController useremail = TextEditingController();
  CollectionReference userdetail =
      FirebaseFirestore.instance.collection("UserDetails");
  String userpass = "";
  int count = 0;
  getuserforgetpassword(String email) async {
    QuerySnapshot detail =
        await userdetail.where("user_email", isEqualTo: email).get();
    for (var element in detail.docs) {
      userpass = element['user_password'];
    }
  }

  Future<int> getUserAuthenticateEmail(String email) async {
    AggregateQuery count =
        userdetail.where("user_email", isEqualTo: email).count();
    AggregateQuerySnapshot snap = await count.get();

    return snap.count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 50, left: 0)),
            Align(
              child: Text(
                "Forget Password",
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
                    icon: Icon(Icons.email_outlined),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white))),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  await getUserAuthenticateEmail(useremail.text)
                      .then((value) => count = value);
                  if (count > 0) {
                    await getuserforgetpassword(useremail.text);
                    useremail.clear();
                    await showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text('Your Password is: $userpass'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else
                  {
                    useremail.clear();
                   await showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Failed'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const [
                                Text('Email not Found or didnot Exist!'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 0.5, color: Colors.white),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: const Text("Forget Password"),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
