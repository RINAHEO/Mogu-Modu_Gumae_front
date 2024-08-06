import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFE9F8FF),
          onPressed: () {
            // 이 버튼을 눌렀을 때 실행될 동작을 정의하세요.
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.68, -0.73),
              end: Alignment(-0.68, 0.73),
              colors: [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // 이 버튼을 눌렀을 때 실행될 동작을 정의하세요.
            },
            color: Color(0xFFFFD3F0),
          ),
        ],
      ),
      body: Center(
        child: Text('Main Content'),
      ),
      bottomNavigationBar: Row(
      ),
    );
  }
}