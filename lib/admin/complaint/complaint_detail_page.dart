import 'package:flutter/material.dart';

class ComplaintDetailPage extends StatelessWidget {
  ComplaintDetailPage({super.key});

  final TextEditingController responseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFFFE9F8),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.68, -0.73),
              end: Alignment(-0.68, 0.73),
              colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              color: Color(0xFFD9BFB8), // 이미지 배경 색상 설정
              child: Center(
                child: Text(
                  '문의 사진',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '이상한 남자가 말 걸어요',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 16,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text('김찬'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '이상한 김찬 명지찬 반찬 김밥천국입니다.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Text(
              '처리상태 : 대기중',
              style: TextStyle(
                color: Color(0xFFB34FD1),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Color(0xFFF5F5F5), // 관리자 답변 배경색
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('관리자 허찬'),
                    SizedBox(height: 6),
                    Text('게이'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
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
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // postResponse(context);
                  },
                  splashColor: Colors.white.withOpacity(0.2),
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
                        '답변 등록',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

