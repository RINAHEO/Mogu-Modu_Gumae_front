import 'package:flutter/material.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFD3F0),
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
      ),
      body: Center(
        child: Text('Main Content'),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.only(top: 9, left: 11, right: 12, bottom: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14737373),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  color: Color(0xFFB34FD1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    '등록하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}