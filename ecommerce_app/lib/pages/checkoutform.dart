// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/pages/feedbackreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckoutFormPage extends StatefulWidget {
  final String email;
  final String username;
  final bool status;
  final dynamic userid;
  final int total;
  final String usercontact;
  final List<QueryDocumentSnapshot<Object?>> cartlist;
  const CheckoutFormPage(
      {super.key,
      required this.email,
      required this.username,
      required this.status,
      required this.cartlist,
      this.userid,
      required this.total,
      required this.usercontact});

  @override
  State<CheckoutFormPage> createState() => _CheckoutFormPageState();
}

class _CheckoutFormPageState extends State<CheckoutFormPage> {
  FirebaseFirestore database = FirebaseFirestore.instance;

  int count = 0;
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController accountnumber = TextEditingController();
  TextEditingController cvcode = TextEditingController();
  TextEditingController expmonth = TextEditingController();
  TextEditingController expyear = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text("Checkout Form"),
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
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              (widget.email.isEmpty &&
                      widget.username.isEmpty &&
                      widget.usercontact.isEmpty &&
                      widget.status == false &&
                      widget.userid != null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 380.0,
                          child: TextField(
                            controller: email,
                            decoration: const InputDecoration(
                              hintText: "Enter Email",
                              labelText: "Email",
                              icon: Icon(Icons.mail_outline),
                              fillColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 380.0,
                          child: TextField(
                            controller: name,
                            decoration: const InputDecoration(
                              hintText: "Enter Name",
                              labelText: "Username",
                              icon: Icon(Icons.person),
                              fillColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 380.0,
                          child: TextField(
                            controller: contact,
                            decoration: const InputDecoration(
                              hintText: "Enter Usercontact",
                              labelText: "Contact",
                              icon: Icon(Icons.phone),
                              fillColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(),
              SizedBox(
                width: 380.0,
                child: TextField(
                  controller: accountnumber,
                  decoration: const InputDecoration(
                    hintText: "Enter Account Number",
                    labelText: "Account Number",
                    icon: Icon(CupertinoIcons.number),
                    fillColor: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 380.0,
                child: TextField(
                  controller: cvcode,
                  decoration: const InputDecoration(
                    hintText: "Enter Cv Code",
                    labelText: "Cv Code",
                    icon: Icon(Icons.lock_outline),
                    fillColor: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 380.0,
                child: TextField(
                  controller: expmonth,
                  decoration: const InputDecoration(
                    hintText: "Enter Expiry Month",
                    labelText: "Expiry Month",
                    icon: Icon(Icons.calendar_month_outlined),
                    fillColor: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 380.0,
                child: TextField(
                  controller: expyear,
                  decoration: const InputDecoration(
                    hintText: "Enter Expiry Year",
                    labelText: "Expiry Year",
                    icon: Icon(CupertinoIcons.calendar),
                    fillColor: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () async {
                      var uniquekey = UniqueKey().toString();
                      if (email.text.isEmpty &&
                          name.text.isEmpty &&
                          contact.text.isEmpty &&
                          cvcode.text.isNotEmpty &&
                          accountnumber.text.isNotEmpty &&
                          expmonth.text.isNotEmpty &&
                          expyear.text.isNotEmpty &&
                          widget.status == true) {
                        await database.collection("PaymentHistroy").doc().set({
                          "Email": widget.email,
                          "Name": widget.username,
                          "Contact": widget.usercontact,
                          "Userid": widget.userid,
                          "Total": (widget.total),
                          "Date": DateTime.now().toString(),
                          "OrderID": uniquekey,
                        });
                        widget.cartlist.forEach(
                          (element) async {
                            await database
                                .collection("PurchaseItems")
                                .doc()
                                .set({
                              "Orderid": uniquekey,
                              "ProductName": element["Product Name"],
                              "ProductId": element.id,
                              "ProductQuentity": element['Quentity'],
                            });
                          },
                        );
                        widget.cartlist.forEach(
                          (element) async {
                            await database
                                .collection("Cart")
                                .doc(element.id)
                                .delete();
                          },
                        );
                        Timer(const Duration(seconds: 5), () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('successfull'),
                                content: const Text('Payment Has Been Success'),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>FeedbackReviewScreen(
                                                  email: widget.email,
                                                  username: widget.username,
                                                  status: widget.status,
                                                  userid: widget.userid,
                                                  usercontact:
                                                      widget.usercontact, cartlist: widget.cartlist, total: widget.total,
                                                )),
                                      );
                                    },
                                  ),
                                ],
                              );
                            });
                        });
                        
                      } else if (email.text.isNotEmpty &&
                          name.text.isNotEmpty &&
                          contact.text.isNotEmpty &&
                          cvcode.text.isNotEmpty &&
                          accountnumber.text.isNotEmpty &&
                          expmonth.text.isNotEmpty &&
                          expyear.text.isNotEmpty &&
                          widget.status == false) {
                            var uniquekey = UniqueKey().toString();
                        await database.collection("PaymentHistroy").doc().set({
                          "Email": email.text,
                          "Name": name.text,
                          "Contact": contact.text,
                          "Userid": "",
                          "Total": (widget.total),
                          "Date": DateTime.now().toString(),
                          "OrderID": uniquekey,
                        });
                        widget.cartlist.forEach(
                          (element) async {
                            await database
                                .collection("PurchaseItems")
                                .doc()
                                .set({
                              "Orderid": uniquekey,
                              "ProductName": element["Product Name"],
                              "ProductId": element.id,
                              "ProductQuentity": element['Quentity'],
                            });
                            await database
                                .collection("Cart")
                                .doc(element.id)
                                .delete();
                          },
                        );

                       
                        Timer(const Duration(seconds: 5), () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('successfull'),
                                content: const Text('Payment Has Been Success'),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FeedbackReviewScreen(
                                                  email: widget.email,
                                                  username: widget.username,
                                                  status: widget.status,
                                                  userid: widget.userid,
                                                  usercontact:
                                                      widget.usercontact, cartlist: widget.cartlist, total: widget.total,
                                                )),
                                      );
                                    },
                                  ),
                                ],
                              );
                            });
                        });
                         
                      } else {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('unsuccessful'),
                                content: const Text('Please fill all field'),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Ok"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text("Pay",
                        style: TextStyle(color: Colors.white, fontSize: 20))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
