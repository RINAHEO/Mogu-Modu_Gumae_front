import 'package:flutter/material.dart';

class HistoryListPage extends StatelessWidget {
  const HistoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '모구내역',
          style: TextStyle(
            color: Color(0xFFFFE9F8),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false, // 제목을 가운데 정렬하지 않도록 설정
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            color: Color(0xFFFFE9F8),
            onPressed: () {
              // 알림 버튼 클릭 시 동작을 정의하세요.
            },
          ),
        ],
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, '홈', false),
              _buildNavItem(Icons.chat, '채팅', false),
              _buildNavItem(Icons.history, '모구내역', true),
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