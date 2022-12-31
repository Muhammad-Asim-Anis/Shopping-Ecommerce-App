import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/pages/checkout.dart';
import 'package:flutter/material.dart';


class CartPage extends StatefulWidget {
  final String email;
  final dynamic id;
  final bool status;
  final String name;
  final String usercontact;
  const CartPage(
      {super.key,
      required this.email,
      required this.id,
      required this.status,
      required this.name, required this.usercontact});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CollectionReference cartitem = FirebaseFirestore.instance.collection("Cart");
  int count = 0;
  int sum = 0;

  @override
  void initState() {
    super.initState();
    display();
  }

  display() {
    if(widget.status == true)
    {
      cartitem.where("Userid", isEqualTo: widget.id).snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        List<QueryDocumentSnapshot<Object?>> data = event.docs;

        sum = 0;
        for (var element in data) {
          sum += element['Price'] * element['Quentity'] as int;
        }
       
      }
    });

    }
    if(widget.status == false)
    {

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
        title: const Text("Cart"),
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
        stream: (widget.status == false)? cartitem.snapshots(): cartitem.where("Userid",isEqualTo: widget.id).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null)
          {
            return const Text("");
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData && snapshot.data!.size != 0)
          {
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
                Center(
                
                  child: Container(
                    
                    margin: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                    email: widget.email, username: widget.name, userid: widget.id, status: widget.status, usercontact: widget.usercontact,),
                              ));
                        },
                        style: ElevatedButton.styleFrom(elevation: 20),
                        child: Text("Pay  \$$sum"),
                      ),
                    ),
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
