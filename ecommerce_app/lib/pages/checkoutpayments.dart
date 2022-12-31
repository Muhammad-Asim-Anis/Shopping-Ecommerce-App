import 'package:ecommerce_app/pages/cashondeliveryform.dart';
import 'package:ecommerce_app/pages/checkoutform.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutPaymentsScreen extends StatefulWidget {
  final String email;
  final String username;
  final bool status;
  final dynamic userid;
  final int total;
  final String usercontact;
  final List<QueryDocumentSnapshot<Object?>> cartlist;
  const CheckoutPaymentsScreen(
      {super.key,
      required this.email,
      required this.status,
      required this.usercontact,
      required this.username,
      this.userid,
      required this.total,
      required this.cartlist});

  @override
  State<CheckoutPaymentsScreen> createState() => _CheckoutPaymentsScreenState();
}

class _CheckoutPaymentsScreenState extends State<CheckoutPaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text("Checkout Payemts"),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 278,
              height: 37,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutFormPage(
                            email: widget.email,
                            username: widget.username,
                            total: widget.total,
                            cartlist: widget.cartlist,
                            status: widget.status,
                            userid: widget.userid,
                            usercontact: widget.usercontact,
                          ),
                        ));
                  },
                  child: const Text("Online pay")),
            ),
            const SizedBox(
              height: 31,
            ),
            SizedBox(
              width: 278,
              height: 37,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CashonDeliveryformScreen(
                            email: widget.email,
                            username: widget.username,
                            total: widget.total,
                            cartlist: widget.cartlist,
                            status: widget.status,
                            userid: widget.userid,
                            usercontact: widget.usercontact,
                          ),
                        ));
                  },
                  child: const Text("Cash on Delivery pay")),
            )
          ],
        ),
      ),
    );
  }
}
