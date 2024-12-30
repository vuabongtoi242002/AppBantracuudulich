import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:manh_01/pages/home.dart';
import 'package:manh_01/pages/order.dart';
import 'package:manh_01/pages/profile.dart';
import 'package:manh_01/pages/walet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex=0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Profile profile;
  late Order order;
  late Wallet walet;

  @override
  void initState() {
    homepage=Home();
    order=Order();
    profile=Profile();
    walet=Wallet();
    pages=[homepage, order, walet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex=index;
          });
        },
        items: [
          Icon(
            Icons.home_outlined,
            color: Colors.cyanAccent,
          ),
          Icon(
            Icons.add,
            color: Colors.cyanAccent,
          ),
          Icon(
            Icons.wallet_outlined,
            color: Colors.cyanAccent,
          ),
          Icon(
            Icons.person_outlined,
            color: Colors.cyanAccent,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
