import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  CollectionReference users =
      FirebaseFirestore.instance.collection("UserDetails");
  int userid = 1;
  int count = 0;
  bool _isHidden = true;
  bool _isHidden2 = true;
  @override
  void initState() {
    super.initState();
  }

  getlatestid() async {
    QuerySnapshot details = await users.get();
    // ignore: unused_local_variable
    for (var element in details.docs) {
      userid = userid + 1;
    }
  }

  Future<int> getUserAuthenticate(String email, String pass) async {
    AggregateQuery count = users
        .where("user_email", isEqualTo: email)
        .where("user_password", isEqualTo: pass)
        .count();
    AggregateQuerySnapshot snap = await count.get();

    return snap.count;
  }

  TextEditingController useremail = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController userpass = TextEditingController();
  TextEditingController usercfpass = TextEditingController();
  TextEditingController usercontact = TextEditingController();

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
                  "Sign Up",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20, left: 0)),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: username,
                  decoration: const InputDecoration(
                      hintText: "Enter your Username",
                      labelText: "Username",
                      fillColor: Colors.yellow,
                      icon: Icon(Icons.person),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.white))),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20, left: 0)),
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
                          borderSide:
                              BorderSide(width: 2, color: Colors.white))),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20, left: 0)),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: userpass,
                  obscureText: _isHidden2,
                  decoration:  InputDecoration(
                      hintText: "Enter your Password",
                      labelText: "Password",
                      fillColor: Colors.yellow,
                      icon: const Icon(Icons.lock_person),
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
                          borderSide:
                              BorderSide(width: 2, color: Colors.white))),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20, left: 0)),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: usercfpass,
                  obscureText: _isHidden,
                  decoration:  InputDecoration(
                      hintText: "Enter your Confirm Password",
                      labelText: "Confirm Password",
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
                      icon: const Icon(Icons.lock_person_outlined),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.white))),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20, left: 0)),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: usercontact,
                  decoration: const InputDecoration(
                      hintText: "Enter your Contact Number",
                      labelText: "Contact Number",
                      fillColor: Colors.yellow,
                      icon: Icon(Icons.phone),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.white))),
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () async {
                    await getlatestid();
                    await getUserAuthenticate(useremail.text, userpass.text)
                        .then((value) => count = value);

                    if (count > 0) {
                      useremail.clear();
                      userpass.clear();
                      usercfpass.clear();
                      usercontact.clear();
                      username.clear();
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Failed'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const [
                                  Text('User already Exist! '),
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
                    } else {
                      if (username.text.isNotEmpty &&
                          useremail.text.isNotEmpty &&
                          userpass.text.isNotEmpty &&
                          usercfpass.text.isNotEmpty &&
                          usercontact.text.isNotEmpty) {
                        if (userpass.text.contains(usercfpass.text)) {
                          await users.add({
                            'id': userid,
                            'user_contact': usercontact.text.toString(),
                            'user_email': useremail.text.toString(),
                            'user_password': userpass.text.toString(),
                            'username': username.text.toString()
                          });
                          useremail.clear();
                          userpass.clear();
                          usercfpass.clear();
                          usercontact.clear();
                          username.clear();
                          await showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Success'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const [
                                      Text('Register SuccessFully'),
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
                                      Text(
                                          'Password and Confirm Password did not match'),
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
                                    Text('Fill All Fields'),
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
                    }
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
