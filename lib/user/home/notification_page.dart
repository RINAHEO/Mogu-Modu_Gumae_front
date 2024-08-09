import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedTabIndex = 0; // 0: 참여알림, 1: 새소식

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
        title: Text(
          '알림',
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          '참여알림',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedTabIndex == 0
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                      if (_selectedTabIndex == 0)
                        Container(
                          height: 2,
                          color: Color(0xFFB34FD1), // 보라색 선
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          '새소식',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedTabIndex == 1
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                      if (_selectedTabIndex == 1)
                        Container(
                          height: 2,
                          color: Color(0xFFB34FD1), // 보라색 선
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _selectedTabIndex == 0
                ? Center(child: Text('참여알림 내용'))
                : Center(child: Text('새소식 내용')),
          ),
        ],
      ),
    );
  }
}
