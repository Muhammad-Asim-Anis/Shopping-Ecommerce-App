import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/pages/productdetail.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsPage extends StatefulWidget {
  
  final int userid;

  final bool status;
  const ProductsPage({super.key, required this.userid, required this.status});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  CollectionReference productsfirestore =
      FirebaseFirestore.instance.collection("Products");
  CollectionReference category =
      FirebaseFirestore.instance.collection("Categories");
  var setcategory = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text("Products"),
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
