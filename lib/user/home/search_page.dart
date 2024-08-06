import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.68, -0.73),
              end: Alignment(-0.68, 0.73),
              colors: [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 12), // 패딩 조정
            child: Container(
              height: 50, // 핑크색 부분의 높이 조정
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
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20), // 좌우 패딩
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
      ),
      body: Center(
        child: Text('Main Content'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, '홈', true),
              _buildNavItem(Icons.chat, '채팅', false),
              _buildNavItem(Icons.history, '모구내역', false),
              _buildNavItem(Icons.person, 'MY', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xFFB34FD1) : Color(0xFFFFBDE9),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFFB34FD1) : Color(0xFFFFBDE9),
              fontSize: 9,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}