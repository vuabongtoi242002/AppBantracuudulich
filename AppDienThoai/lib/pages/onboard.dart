import 'package:flutter/material.dart';
import 'package:manh_01/pages/signup.dart';
import 'package:manh_01/widget/content_model.dart';
import '../2/VietNam.dart';
import '../widget/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'image$i',
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              contents[i].image,
                              height: 380,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Text(
                        contents[i].title,
                        style: AppWidget.HeadLineTextFeildStyle().copyWith(
                          fontSize: 28,
                          color: Colors.amber.shade800,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black45,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        contents[i].description,
                        style: AppWidget.LightTextFeildStyle().copyWith(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildIndicator(),
          _buildNextButton(context),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(contents.length, (index) => _buildDot(index)),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 12.0,
      width: currentIndex == index ? 24 : 12,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.amber : Colors.grey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: currentIndex == index
            ? [
          BoxShadow(
            color: Colors.amber.withOpacity(0.6),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ]
            : [],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (currentIndex == contents.length - 1) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VietNam()));
        } else {
          _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        }
      },
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(40),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.amber.shade800,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.shade600,
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            currentIndex == contents.length - 1 ? "Start" : "Next",
            style: const TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
