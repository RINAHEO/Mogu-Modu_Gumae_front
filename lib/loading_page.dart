import 'package:flutter/material.dart';
import 'first_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FirstPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        width: 360,
        height: 770,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [Color(0xFFFFA7E1), Color(0xB29322CC)],
          ),
        ),
        child: Center(
          child: Container(
            width: 113,
            height: 104,
            child: Image.asset(
              'assets/Mogulogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
