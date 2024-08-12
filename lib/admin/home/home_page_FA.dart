import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePageFA extends StatefulWidget {
  const HomePageFA({super.key});

  @override
  _HomePageFAState createState() => _HomePageFAState();
}

class _HomePageFAState extends State<HomePageFA> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  TabController? _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener(() {
      setState(() {}); // 탭 변경 시 상태 업데이트
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _searchQuery = ''; // 탭을 변경할 때 검색어 초기화
    });
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<Widget> _buildSearchResults() {
    List<Widget> results = [];
    if (_selectedIndex == 0) {
      // 홈탭: 게시물 검색
      results = [
        Text('홈탭 검색 결과: $_searchQuery'),
      ];
    } else if (_selectedIndex == 1) {
      // 회원관리탭: 유저 아이디 검색
      results = [
        Text('회원관리 검색 결과: $_searchQuery'),
      ];
    } else if (_selectedIndex == 2) {
      if (_tabController?.index == 0) {
        // 민원관리탭 문의: 문의 제목 검색
        results = [
          Text('문의 검색 결과: $_searchQuery'),
        ];
      } else if (_tabController?.index == 1) {
        // 민원관리탭 신고: 신고 내용 검색
        results = [
          Text('신고 검색 결과: $_searchQuery'),
        ];
      } else if (_tabController?.index == 2) {
        // 민원관리탭 공지: 공지 제목 검색
        results = [
          Text('공지 검색 결과: $_searchQuery'),
        ];
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.reorder),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            print('Reorder button pressed');
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 30, // 검색창의 높이
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFBDE9),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          isDense: true,
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.white.withOpacity(0.3), // 물결 효과 색상
                      onTap: _performSearch,
                      child: Icon(
                        Icons.search,
                        color: Color(0xFFFFD3F0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.68, -0.73),
              end: Alignment(-0.68, 0.73),
              colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
        elevation: 0,
        bottom: _selectedIndex == 2
            ? PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white, // 탭 배경색을 흰색으로 설정
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFFB34FD1), // 선택된 탭의 글자 색상 (보라색)
              unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 글자 색상 (회색)
              indicatorColor: Color(0xFFB34FD1), // 선택된 탭의 하단 인디케이터 색상 (보라색)
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab, // 인디케이터 길이를 탭 전체로 설정
              tabs: const [
                Tab(text: '문의'),
                Tab(text: '신고'),
                Tab(text: '공지'),
              ],
            ),
          ),
        )
            : null,
      ),
      body: _selectedIndex == 2
          ? Container(
        color: Colors.white, // TabBarView 전체의 배경색을 설정
        child: TabBarView(
          controller: _tabController,
          children: const [
            Center(child: Text('문의 내용 표시')),
            Center(child: Text('신고 내용 표시')),
            Center(child: Text('공지 내용 표시')),
          ],
        ),
      )
          : Container(
        color: Colors.white, // 기본 배경색 설정
        child: ListView(
          children: _buildSearchResults(),
        ),
      ),
      floatingActionButton: _selectedIndex == 2 && _tabController?.index == 2
          ? ClipOval(
        child: Material(
          color: Colors.white.withOpacity(0.1), // 버튼 배경색을 약간 불투명하게 설정
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.3), // 물결 효과 색상
            onTap: () {
              print('플로팅 액션 버튼 클릭됨');
            },
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/post_create_button.svg",
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      )
          : null, // 다른 탭에서는 플로팅 액션 버튼을 숨김
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting, // 애니메이션 효과를 위한 설정
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/unselected_home.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/selected_home.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/unselected_member_management.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/selected_member_management.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '회원관리',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/unselected_complaint_management.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/selected_complaint_management.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '민원관리',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFB34FD1),
        unselectedItemColor: Color(0xFFFFBDE9),
        onTap: _onItemTapped,
      ),
    );
  }
}

