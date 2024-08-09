import 'package:flutter/material.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  _AccountManagementPage createState() => _AccountManagementPage();
}

class _AccountManagementPage extends State<AccountManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 돌아가기
          },
        ),
        title: Text(
          '계정관리',
          style: TextStyle(
            color: Color(0xFFFFD3F0),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('아이디', '10209210'),
              _buildInfoRow('비밀번호', '********', hasButton: true),
              _buildInfoRow('이름', '모지환'),
              _buildInfoRow('성별', '남자'),
              _buildInfoRow('전화번호', '01000000000'),
              _buildInfoRow('주소', '서울 서대문구 남가좌동 명지대학교'),
              _buildInfoRow('이메일', 'mobifan@gmail.com'),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // 회원탈퇴 로직 추가
                  },
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline, // 밑줄 추가
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool hasButton = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Aligns the row items vertically centered
        children: [
          SizedBox(
            width: 80, // Provide a fixed width for titles to align them properly
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (hasButton)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0), // 텍스트와 버튼 사이의 간격을 조정
                    child: ElevatedButton(
                      onPressed: () {
                        // 비밀번호 변경 로직 추가
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color(0xFF5F5F5F), // 글자색을 흰색으로 설정
                        minimumSize: Size(35, 25),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('변경', style: TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
