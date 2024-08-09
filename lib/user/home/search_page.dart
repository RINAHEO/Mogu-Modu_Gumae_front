import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 동작을 정의
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
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // 패딩 조정
          child: Container(
            height: 35, // 핑크색 부분의 높이 조정
            decoration: BoxDecoration(
              color: Color(0xFFFFBDE9),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20), // 좌우 패딩
                      isDense: true, // 밀집된 형태로 만들기
                    ),
                  ),
                ),
                Padding(
                  // 여기에 패딩 추가
                  padding: const EdgeInsets.only(right: 8.0), // 오른쪽 패딩 조정
                  child: IconButton(
                    icon: Icon(Icons.search),
                    color: Color(0xFFFFD3F0),
                    padding: EdgeInsets.zero, // 기본 패딩 제거
                    constraints: BoxConstraints(), // 아이콘의 크기 조정
                    onPressed: () {
                      // 이 버튼을 눌렀을 때 실행될 동작을 정의하세요.
                      print('Search button pressed');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Main Content'),
      ),
    );
  }
}
