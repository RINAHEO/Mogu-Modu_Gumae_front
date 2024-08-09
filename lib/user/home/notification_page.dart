import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 알림 데이터 생성
    List<Map<String, String>> notifications = List.generate(20, (index) {
      return {
        'title': '모비짱님이 참여신청 했습니다.',
        'time': '${38 + index}초전',
      };
    });

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFFB34FD1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFFB34FD1),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFFB34FD1), width: 3),
                insets: EdgeInsets.symmetric(horizontal: 0.0), // 탭 아래의 선을 넓게 설정
              ),
              tabs: [
                Tab(text: '참여알림'),
                Tab(text: '새소식'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 1,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // 알림 항목 클릭 시 동작 추가
                },
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                  title: Text(notifications[index]['title']!),
                  subtitle: Text(notifications[index]['time']!),
                  trailing: Icon(Icons.chevron_right),
                ),
              );
            },
          ),
          Center(child: Text('새소식 탭 내용 표시')),
        ],
      ),
    );
  }
}


