// import 'package:ecommerce_app/login.dart';

// ignore_for_file: avoid_unnecessary_containers

import 'package:badges/badges.dart';
import 'package:ecommerce_app/pages/cart.dart';

import 'package:ecommerce_app/pages/homedrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/pages/maindrawer.dart';
import 'package:ecommerce_app/pages/productdetail.dart';
import 'package:ecommerce_app/pages/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(title: "E commerce App") 
    );
  }
}

class HomePage extends StatefulWidget {
  final String email;
  final String name;
  final int userid;
  final String usercontact;
  final bool status;
  const HomePage(
      {super.key,
      required this.email,
      required this.name,
      required this.userid,
      required this.usercontact,
      required this.status});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference productsfirestore =
      FirebaseFirestore.instance.collection("Products");
  CollectionReference category =
      FirebaseFirestore.instance.collection("Categories");
  CollectionReference cartitem = FirebaseFirestore.instance.collection("Cart");

  var setcategory = "";
  var cartcount = 0;
  @override
  void initState() {
    super.initState();
    if (widget.status == true) {
      getusercartcount();
    } else {
      getcartcount();
    }
  }

  getusercartcount() async {
    AggregateQuery cart =
        cartitem.where("Userid", isEqualTo: widget.userid).count();
    AggregateQuerySnapshot cartsnap = await cart.get();
    setState(() {
      cartcount = cartsnap.count;
    });
  }

  getcartcount() async {
    AggregateQuery cart = cartitem.where("Userid", isEqualTo: "").count();
    AggregateQuerySnapshot cartsnap = await cart.get();
    setState(() {
      cartcount = cartsnap.count;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == true) {
      getusercartcount();
    } else {
      getcartcount();
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Home"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(width: 0, color: Colors.blue),
                        elevation: 0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(
                              email: widget.email,
                              name: widget.name,
                              id: widget.userid,
                              status: widget.status,
                              usercontact: widget.usercontact,
                            ),
                          ));
                    },
                    child: Badge(
                        badgeContent: (cartcount > 0)
                            ? Text('$cartcount')
                            : const Text('0'),
                        animationType: BadgeAnimationType.scale,
                        child: const Icon(
                          CupertinoIcons.cart,
                        ))))
          ],
        ),
        drawer: (widget.email.isNotEmpty &&
                widget.name.isNotEmpty &&
                widget.status == true &&
                widget.usercontact.isNotEmpty &&
                widget.userid != 0)
            ? MainDrawer(
                email: widget.email,
                name: widget.name,
                status: widget.status,
                usercontact: widget.usercontact,
                userid: widget.userid,
              )
            : const HomeDrawer(),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: StreamBuilder(
                        stream: category.snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text("");
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot procat =
                                  snapshot.data!.docs[index];
                              return Container(
                                  margin: const EdgeInsets.all(5),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (procat['category'] != "All") {
                                            setcategory = procat['category'];
                                          } else {
                                            setcategory = "";
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: const StadiumBorder()),
                                      child: Text(
                                        procat["category"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )));
                            },
                          );
                        }),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: (setcategory.isEmpty)
                          ? productsfirestore.snapshots()
                          : productsfirestore
                              .where("category", isEqualTo: setcategory)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot document =
                                snapshot.data!.docs[index];

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductPage(
                                              id: document['id'] as int,
                                              category: document['category'],
                                              desc: document['description'],
                                              image: document['image'],
                                              price:
                                                  document['price'] ,
                                              rating: document['rating'],
                                              title: document['title'],
                                              productid: document.id,
                                              login: widget.status,
                                              usercartid: widget.userid,
                                            )));
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 20,
                                margin: const EdgeInsets.all(10),
                                child: SizedBox(height: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: NetworkImage(document['image']),
                                        width: 150,
                                        height: 100,
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          
                                          child: Text(
                                            document['title'],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                               
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
