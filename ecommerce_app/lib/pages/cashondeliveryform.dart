// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/pages/deliverytocustomer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

class CashonDeliveryformScreen extends StatefulWidget {
  final String email;
  final String username;
  final bool status;
  final dynamic userid;
  final int total;
  final String usercontact;
  final List<QueryDocumentSnapshot<Object?>> cartlist;
  const CashonDeliveryformScreen(
      {super.key,
      required this.email,
      required this.username,
      required this.status,
      required this.cartlist,
      this.userid,
      required this.total,
      required this.usercontact});

  @override
  State<CashonDeliveryformScreen> createState() =>
      _CashonDeliveryformScreenState();
}

class _CashonDeliveryformScreenState extends State<CashonDeliveryformScreen> {
  FirebaseFirestore database = FirebaseFirestore.instance;

  int count = 0;
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();

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
        title: const Text("Cash on Delivery Form"),
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
                  controller: address,
                  decoration: const InputDecoration(
                    hintText: "Enter Address Delivery",
                    labelText: "Address",
                    icon: Icon(CupertinoIcons.number),
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
                        Uint8List? markerimage;       
                      if (email.text.isEmpty &&
                          name.text.isEmpty &&
                          contact.text.isEmpty &&
                          address.text.isNotEmpty &&
                          widget.status == true) {
                            
                        await database.collection("PaymentHistroy").doc().set({
                          "Email": widget.email,
                          "Name": widget.username,
                          "Contact": widget.usercontact,
                          "Userid": widget.userid,
                          "Useraddress": address.text.toString(),
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
                                  content: const Text('Proceed to next Screen'),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Ok"),
                                      onPressed: () async {
                                         
                                        List<Location> locations =
                                            await locationFromAddress(
                                                address.text.toString());

                                        Future<Uint8List> getbytesfromAssets(
                                            String path, int width) async {
                                          ByteData data =
                                              await rootBundle.load(path);
                                          ui.Codec codec =
                                              await ui.instantiateImageCodec(
                                                  data.buffer.asUint8List(),
                                                  targetHeight: width);
                                          ui.FrameInfo fi =
                                              await codec.getNextFrame();

                                          return (await fi.image.toByteData(
                                                  format:
                                                      ui.ImageByteFormat.png))!
                                              .buffer
                                              .asUint8List();
                                        }

                                        
                                          
                                          markerimage = await getbytesfromAssets(
                                              "assets/images/cargo-truck.png",
                                              50);        
                                        //ignore: use_build_context_synchronously
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeliverytoCustomerProcessScreen(
                                                    cartlist: widget.cartlist,
                                                    email: widget.email,
                                                    latitude:
                                                        locations.last.latitude,
                                                    longtitude: locations
                                                        .last.longitude,
                                                    status: widget.status,
                                                    total: widget.total,
                                                    usercontact:
                                                        widget.usercontact,
                                                    username: widget.username,
                                                    userid: widget.userid,
                                                    markericon: markerimage!,
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
                          address.text.isNotEmpty &&
                          widget.status == false) {
                        var uniquekey = UniqueKey().toString();
                       
                        await database.collection("PaymentHistroy").doc().set({
                          "Email": email.text,
                          "Name": name.text,
                          "Contact": contact.text,
                          "Userid": "",
                          "Useraddress": address.text.toString(),
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
                                  content: const Text('Proceed to next Screen'),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Ok"),
                                      onPressed: () async {
                                        List<Location> locations =
                                            await locationFromAddress(
                                                address.text.toString());

                                        Future<Uint8List> getbytesfromAssets(
                                            String path, int width) async {
                                          ByteData data =
                                              await rootBundle.load(path);
                                          ui.Codec codec =
                                              await ui.instantiateImageCodec(
                                                  data.buffer.asUint8List(),
                                                  targetHeight: width);
                                          ui.FrameInfo fi =
                                              await codec.getNextFrame();

                                          return (await fi.image.toByteData(
                                                  format:
                                                      ui.ImageByteFormat.png))!
                                              .buffer
                                              .asUint8List();
                                        }

                                        
                                          
                                          markerimage = await getbytesfromAssets(
                                              "assets/images/cargo-truck.png",
                                              50);
                

                                        // ignore: use_build_context_synchronously
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeliverytoCustomerProcessScreen(
                                                    cartlist: widget.cartlist,
                                                    email: email.text,
                                                    latitude:
                                                        locations.last.latitude,
                                                    longtitude: locations
                                                        .last.longitude,
                                                    status: widget.status,
                                                    total: widget.total,
                                                    usercontact: contact.text,
                                                    username: name.text,
                                                    userid: "",
                                                    markericon: markerimage!,
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
                    child: const Text("Proceed",
                        style: TextStyle(color: Colors.white, fontSize: 20))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
