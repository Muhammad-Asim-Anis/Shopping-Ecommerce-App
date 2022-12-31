import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_app/pages/checkoutpayments.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final String email;
  final String username;
  final dynamic userid;
  final bool status;
  final String usercontact;
  const CheckoutPage(
      {super.key,
      required this.email,
      required this.username,
      required this.userid,
      required this.status, required this.usercontact});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CollectionReference cartitem = FirebaseFirestore.instance.collection("Cart");
  int count = 0;
  int sum = 0;
  int tex = 3;

 
  List<QueryDocumentSnapshot<Object?>> cartlist = [];

  @override
  void initState() {
    super.initState();
    display();
  }

  display() {
    if (widget.status == true) {
      cartitem
          .where("Userid", isEqualTo: widget.userid)
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          List<QueryDocumentSnapshot<Object?>> data = event.docs;

          sum = 0;
          for (var element in data) {
            sum += element['Price'] * element['Quentity'] as int;
          }
        }
      });
    }
    if (widget.status == false) {
      cartitem.where("Userid", isEqualTo: "").snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          List<QueryDocumentSnapshot<Object?>> data = event.docs;

          sum = 0;
          for (var element in data) {
            sum += element['Price'] * element['Quentity'] as int;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text("Checkout"),
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
      body: StreamBuilder(
        stream: (widget.status == false)
            ? cartitem.snapshots()
            : cartitem.where("Userid", isEqualTo: widget.userid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Text("");
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data!.size != 0) {
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot document =
                          snapshot.data!.docs[index];
                      return Card(
                        elevation: 20,
                        margin: const EdgeInsets.all(10),
                        child: ExpansionTile(
                          title: Text(document['Product Name']),
                          leading: Image(
                            image: NetworkImage("${document['image']}"),
                            width: 30,
                            height: 30,
                          ),
                          subtitle: Text("\$${document['Price']}"),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      count = document['Quentity'];
                                      count++;
                                      await cartitem.doc(document.id).update({
                                        "Quentity": count,
                                      });
                                    },
                                    child: const Icon(Icons.add)),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    "${document['Quentity']}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      count = document['Quentity'];
                                      (count != 0) ? count-- : count = 0;

                                      await cartitem.doc(document.id).update({
                                        "Quentity": count,
                                      });
                                    },
                                    child: const Icon(Icons.remove)),
                                ElevatedButton(
                                    onPressed: () {
                                      cartitem.doc(document.id).delete();
                                    },
                                    child: const Icon(Icons.delete)),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  Card(
                    color: Colors.blueAccent,
                    elevation: 20,
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "SubTotal:",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "\$$sum",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Tex:",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "\$$tex",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 300,
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "\$${sum + tex}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          onPressed: ()  {
                         if(widget.status == false) 
                         {

                             cartitem.where("Userid",isEqualTo: "").snapshots().listen((event) async {
                              
                              if (event.docs.isNotEmpty) {
                               cartlist = event.docs;
                              
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPaymentsScreen(
                                    email: widget.email,
                                    username: widget.username,
                                    total: (sum + tex),
                                    cartlist: cartlist,
                                    status: widget.status,
                                    userid: widget.userid, usercontact: widget.usercontact,
                                  ),
                                ));
                              
                               
                            });
                         }  
                         if(widget.status == true)
                         {
                           cartitem.where("Userid",isEqualTo: widget.userid).snapshots().listen((event) async {
                              
                              if (event.docs.isNotEmpty) {
                               cartlist = event.docs;
                              
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPaymentsScreen(
                                    email: widget.email,
                                    username: widget.username,
                                    total: (sum + tex),
                                    cartlist: cartlist,
                                    status: widget.status,
                                    userid: widget.userid, usercontact: widget.usercontact,
                                  ),
                                ));
                               
                            });
                         }
                         
                         
                            
                            
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 46, 97, 185),
                              padding: const EdgeInsets.all(15)),
                          child: const Text("Payment",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text("Cart is Empty"));
        },
      ),
    );
  }
}
