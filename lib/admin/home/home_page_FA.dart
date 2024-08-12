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
  String _selectedSort = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener(() {
      setState(() {}); // 탭 변경 시 상태 업데이트
    });
    _selectedSort = _getInitialSortValue(); // 초기 정렬 값 설정
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
      _selectedSort = _getInitialSortValue(); // 탭 변경 시 기본 정렬 옵션 설정
    });
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  String _getInitialSortValue() {
    if (_selectedIndex == 0) {
      return '최신순';
    } else if (_selectedIndex == 1) {
      return '신고 많은 순';
    } else if (_selectedIndex == 2 && _tabController?.index == 1) {
      return '신고 많은 순';
    } else {
      return '최신순';
    }
  }

  List<String> _getDropdownOptions() {
    if (_selectedIndex == 0) {
      // 홈 화면
      return ['최신순', '조회수 높은순'];
    } else if (_selectedIndex == 1) {
      // 회원관리 화면
      return ['신고 많은 순', '신고 적은 순'];
    } else if (_selectedIndex == 2 && _tabController?.index == 1) {
      // 민원관리의 신고 탭
      return ['신고 많은 순', '최신순'];
    } else {
      // 기본값
      return ['최신순'];
    }
  }

  List<Widget> _buildSearchResults() {
    // 홈 탭에서만 게시글을 표시합니다.
    List<Map<String, String>> posts = [
      {
        'profileName': '김찬',
        'distance': '1~2km',
        'description': '방금 구매한 계란 5개씩 나눠실분..',
        'price': '2000원',
        'imagePath': 'icon',
        'endDate': '12/12',
        'views': '23',
      },
      {
        'profileName': '나하리',
        'distance': '500m 미만',
        'description': '~~위치에 필터가 10개에 6000원 필요하신분 있습니다.',
        'price': '2000원',
        'imagePath': 'icon',
        'endDate': '12/14',
        'views': '30',
      },
      {
        'profileName': '모비팡',
        'distance': '500m ~1km',
        'description': '손수 만든 인증기능 판매합니다',
        'price': '2000원',
        'imagePath': 'icon',
        'endDate': '12/16',
        'views': '45',
      },
    ];

    // 검색어가 있으면 필터링
    if (_searchQuery.isNotEmpty) {
      posts = posts
          .where((post) => post['description']!.contains(_searchQuery))
          .toList();
    }

    // 필터링된 게시글을 위젯으로 변환
    List<Widget> results = posts.map((post) {
      return _buildPostCard(
        profileName: post['profileName']!,
        distance: post['distance']!,
        description: post['description']!,
        price: post['price']!,
        imagePath: post['imagePath']!,
        endDate: post['endDate']!,
        views: post['views']!,
      );
    }).toList();

    return results;
  }

  @override
  Widget build(BuildContext context) {
    // 드롭다운 값이 옵션 리스트에 포함되어 있는지 확인
    final dropdownOptions = _getDropdownOptions();
    if (!dropdownOptions.contains(_selectedSort)) {
      _selectedSort = dropdownOptions.first;
    }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 110, // 드롭다운의 고정된 너비를 설정
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSort,
                    items: dropdownOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                color: Color(0xFFB34FD1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSort = newValue!;
                      });
                    },
                    style: TextStyle(color: Colors.purple), // 글자 색상
                    dropdownColor: Colors.white, // 드롭다운 배경색
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFFB34FD1)), // 기본 화살표 아이콘 추가
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _selectedIndex == 0
                ? ListView(
              padding: EdgeInsets.all(8),
              children: _buildSearchResults(),
            )
                : _buildTabContent(),
          ),
        ],
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

  Widget _buildTabContent() {
    // 회원관리 및 민원관리에서 표시할 컨텐츠를 정의합니다.
    if (_selectedIndex == 1) {
      // 회원관리 탭
      return Center(
        child: Text('회원관리 탭 내용'),
      );
    } else if (_selectedIndex == 2) {
      // 민원관리 탭
      return TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('문의 내용 표시')),
          Center(child: Text('신고 내용 표시')),
          Center(child: Text('공지 내용 표시')),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildPostCard({
    required String profileName,
    required String distance,
    required String description,
    required String price,
    required String imagePath,
    required String endDate,
    required String views,
  }) {
    return InkWell(
      onTap: () {
        print('$profileName 게시글 클릭됨');
      },
      splashColor: Colors.purple.withOpacity(0.3), // 물결 효과 색상
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.person), // 프로필 이미지를 여기에 추가할 수 있음
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        distance,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(description, style: TextStyle(fontSize: 14)),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('모구카', style: TextStyle(color: Colors.pink)),
                  ),
                  SizedBox(width: 8),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Icon(Icons.image, size: 56), // 임시 아이콘 사용
                      SizedBox(height: 4),
                      Text(
                        '10% 더 싸요',
                        style: TextStyle(color: Colors.purple, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text(endDate, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Spacer(),
                  Icon(Icons.comment, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text('2/3', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 8),
                  Icon(Icons.remove_red_eye, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text(views, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 8),
                  Icon(Icons.favorite_border, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text('23', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
