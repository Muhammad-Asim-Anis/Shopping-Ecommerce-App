import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:checkmark/checkmark.dart';

class ProductPage extends StatefulWidget {
  final bool login;
  final int id;
  final String productid;
  final String title;
  final String category;
  final String desc;
  final String image;
  final dynamic price;
  final int rating;
  final int usercartid;

  const ProductPage(
      {super.key,
      required this.id,
      required this.title,
      required this.category,
      required this.desc,
      required this.image,
      required this.price,
      required this.rating,
      required this.productid,
      required this.login,
      required this.usercartid});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  CollectionReference products =
      FirebaseFirestore.instance.collection("Products");
  CollectionReference cartitem = FirebaseFirestore.instance.collection("Cart");
  // CollectionReference usercartitem =
  //     FirebaseFirestore.instance.collection("UserCart");
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
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
      body: Column(children: [
        const SizedBox(height: 15),
        Container(
          height: MediaQuery.of(context).size.height * .35,
          padding: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          child: Image.network(widget.image),
        ),
        Expanded(
            child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chanel',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.title,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '\$${widget.price}',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.desc,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row( mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () => setState(() {
                                    count++;
                                  }),
                              child: const Icon(Icons.add)),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "$count",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () => setState(() {
                                    (count != 0) ? count-- : count = 0;
                                  }),
                              child: const Icon(CupertinoIcons.minus)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          initialRating: widget.rating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) async {
                            await products.doc(widget.productid).update({
                              "rating": rating.toInt(),
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ]),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 150, child: Text("Total: \$${count * widget.price}")),
            Expanded(
                child: InkWell(
              onTap: () async {
                if (count != 0 && widget.login == true) {
                  await cartitem.doc("${widget.productid}1").set({
                    "Userid": widget.usercartid,
                    "Product Name": widget.title,
                    "Price": widget.price,
                    "Quentity": count,
                    "image": widget.image,
                  });
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                          child: AlertDialog(
                            title: const SizedBox(
                              height: 50,
                              width: 50,
                              child: CheckMark(
                                active: true,
                                curve: Curves.decelerate,
                                duration: Duration(milliseconds: 500),
                              ),
                            ),
                            content: const Text('Item Add to Cart'),
                            actions: [
                              ElevatedButton(
                                child: const Text("Ok"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                }
                if (count != 0 && widget.login == false) {
                  await cartitem.doc(widget.productid).set({
                    "Userid": "",
                    "Product Name": widget.title,
                    "Price": widget.price,
                    "Quentity": count,
                    "image": widget.image,
                  });
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const SizedBox(
                            height: 50,
                            width: 50,
                            child: CheckMark(
                              active: true,
                              curve: Curves.decelerate,
                              duration: Duration(milliseconds: 500),
                            ),
                          ),
                          content: const Text('Item Add to Cart'),
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
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text("Book Now"),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
