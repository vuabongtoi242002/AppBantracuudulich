import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manh_01/admin/admin_login.dart';
import 'package:manh_01/service/database.dart';

import '../widget/widget_support.dart';
import 'details.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool chau_a = false, chau_au = false, chau_dai_duong = false, nam_mi = false;

  Stream? worditemStream;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  ontheload() async {
    worditemStream = await DatabaseMethods().getWordItem("chau_a");
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget allItems() {
    return StreamBuilder(
      stream: worditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var filteredDocs = (snapshot.data as QuerySnapshot).docs.where((doc) {
            return (doc as QueryDocumentSnapshot)['Name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredDocs.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = filteredDocs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Details(
                      detail: ds["Detail"],
                      image: ds["Image"],
                      name: ds["Name"],
                    ),
                  ));
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              ds["Image"],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            ds["Name"],
                            style: AppWidget.semBooldTextFeildStyle().copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  Widget allItemsVerticall() {
    return StreamBuilder(
      stream: worditemStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var filteredDocs = (snapshot.data as QuerySnapshot).docs.where((doc) {
            return (doc as QueryDocumentSnapshot)['Name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredDocs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = filteredDocs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Details(
                      detail: ds["Detail"],
                      image: ds["Image"],
                      name: ds["Name"],
                    ),
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              ds["Image"],
                              height: 120,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    ds["Name"],
                                    style: AppWidget.HeadLineTextFeildStyle().copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center, // Center text horizontally
                                  ),
                                  // Uncomment and style the next line if needed
                                  // SizedBox(height: 5),
                                  // Text(
                                  //   ds["detail2"],
                                  //   style: AppWidget.LightTextFeildStyle(),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: (val) {
          setState(() {
            searchQuery = val;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello",
                    style: AppWidget.boldTextFeildStyle().copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.lock),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminLogin()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              searchBar(),
              SizedBox(height: 20),
              Text(
                "Châu lục",
                style: AppWidget.HeadLineTextFeildStyle().copyWith(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Châu lục của thế giới!",
                style: AppWidget.LightTextFeildStyle().copyWith(fontSize: 16),
              ),
              SizedBox(height: 20),
              showItem(),
              SizedBox(height: 28),
              Container(
                height: 250,
                child: allItems(),
              ),
              SizedBox(height: 30),
              allItemsVerticall(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        categoryButton("chau_a", "image/chau_a.png", chau_a),
        categoryButton("chau_au", "image/chau_au.png", chau_au),
        categoryButton("chau_dai_duong", "image/chau_dai_duong.png", chau_dai_duong),
        categoryButton("nam_mi", "image/nam_mi.png", nam_mi),
      ],
    );
  }

  Widget categoryButton(String category, String imagePath, bool isSelected) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          chau_a = category == "chau_a";
          chau_au = category == "chau_au";
          chau_dai_duong = category == "chau_dai_duong";
          nam_mi = category == "nam_mi";
        });
        worditemStream = await DatabaseMethods().getWordItem(category);
      },
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey : Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(8),
          child: Image.asset(
            imagePath,
            height: 55,
            width: 55,
            fit: BoxFit.cover,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
