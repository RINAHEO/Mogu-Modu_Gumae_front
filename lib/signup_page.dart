import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // 그림자 제거
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFB34FD1)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Container(
            color: Colors.white,
            width: screenWidth,
            height: screenHeight,
          );
        },
      ),
    );
  }
}
