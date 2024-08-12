import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mogu_app/user/chat/chat_room_page.dart';
import 'package:mogu_app/user/home/post/post_create_page.dart';
import 'package:mogu_app/user/home/search_page.dart';
import 'package:mogu_app/user/myPage/account_management_page.dart';
import 'package:mogu_app/user/home/post/post_detail_page.dart';

import '../myPage/setting_page.dart';
import '../myPage/update_profile_page.dart';
import 'menu_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  int _selectedIndex = 0;
  late TabController _tabController;

  String _selectedSortOption = '최신순';
  final List<String> _sortOptions = ['최신순', '가까운 순'];
  double _currentDistanceValue = 2.0; // 초기 거리 값 설정

  // 상태 관리용 변수 추가
  String _selectedRecruitmentStatus = '모집중';
  String _selectedPurchaseRoute = '오프라인';
  String _selectedPurchaseStatus = '미구입';
  String _selectedChatFilter = '전체';

  // 홈 화면의 게시글 데이터
  final List<Map<String, dynamic>> posts = [
    {
      'username': '김찬',
      'distance': '1~2km',
      'title': '방금 구매한 계란 5개씩 나누실분...',
      'price': '2000원',
      'participants': 2,
      'maxParticipants': 3,
      'likes': 7,
      'comments': 23,
    },
    {
      'username': '나혜리',
      'distance': '500m 미만',
      'title': '~~~원치에 물티슈 10개에 6000원 원하시는분',
      'price': '2000원',
      'participants': 2,
      'maxParticipants': 3,
      'likes': 7,
      'comments': 23,
    },
    // 다른 게시글들...
  ];

  // 채팅 목록 데이터
  final List<Map<String, String>> chatItems = List.generate(
    6,
        (index) => {
      'title': '그럼 명지대학교에서 뵙겠습니다',
      'time': '오후 9시 13분',
    },
  );

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741', // 배너 광고 테스트 ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Failed to load a banner ad: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSortOptionChanged(String? newValue) {
    setState(() {
      _selectedSortOption = newValue!;
    });
  }

  void _showSearchOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 전체 높이 제어
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '검색 옵션',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('나와의 거리'),
                  Slider(
                    value: _currentDistanceValue,
                    min: 0,
                    max: 10, // 최대 거리를 10km로 설정 (원하는 값으로 변경 가능)
                    divisions: 10,
                    label: '${_currentDistanceValue.toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setModalState(() {
                        _currentDistanceValue = value;
                      });
                    },
                    activeColor: Color(0xFFB34FD1),
                    inactiveColor: Colors.grey,
                  ),
                  Text(
                    '~ ${_currentDistanceValue.toStringAsFixed(1)}km', // 현재 거리 값을 실시간으로 표시
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  _buildToggleButton(
                    '모집 상태',
                    '모집중',
                    '마감',
                    _selectedRecruitmentStatus,
                        (newValue) {
                      setModalState(() {
                        _selectedRecruitmentStatus = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildToggleButton(
                    '구매 경로',
                    '오프라인',
                    '온라인',
                    _selectedPurchaseRoute,
                        (newValue) {
                      setModalState(() {
                        _selectedPurchaseRoute = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildToggleButton(
                    '구매 상태',
                    '미구입',
                    '구입완료',
                    _selectedPurchaseStatus,
                        (newValue) {
                      setModalState(() {
                        _selectedPurchaseStatus = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: Colors.grey.shade200,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('초기화'),
                      ),
                      SizedBox(width: 10), // 초기화 버튼과 적용하기 버튼 사이의 간격
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFB34FD1),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('적용하기'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildToggleButton(String label, String option1, String option2,
      String selectedValue, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  onChanged(option1);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: selectedValue == option1 ? Colors.white : Colors.grey,
                  backgroundColor: selectedValue == option1 ? Color(0xFFB34FD1) : Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(option1),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  onChanged(option2);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: selectedValue == option2 ? Colors.white : Colors.grey,
                  backgroundColor: selectedValue == option2 ? Color(0xFFB34FD1) : Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(option2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatFilterButton(String label) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedChatFilter = label;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor:
        _selectedChatFilter == label ? Colors.grey.shade200 : Colors.white,
        side: BorderSide(
          color: _selectedChatFilter == label ? Colors.black : Colors.grey,
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: 14)),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PostDetailPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      splashColor: Colors.purple.withOpacity(0.2),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${post['username']} • ${post['distance']}'),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.image, size: 50, color: Colors.grey), // 임시 아이콘
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['title'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(post['price'], style: TextStyle(color: Colors.purple)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: const [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey,
                          ),
                          Positioned(
                            left: 12,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Text('${post['participants']}/${post['maxParticipants']}'),
                    ],
                  ),
                  Row(
                    children: [
                      Text('${post['likes']}'),
                      Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('${post['comments']}'),
                      Icon(Icons.comment, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoguHistoryCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PostDetailPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      splashColor: Colors.purple.withOpacity(0.3), // 물결 효과 색상
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.image, size: 60, color: Colors.grey), // 임시 이미지 아이콘
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('명지대사거리 우리은행 앞'),
                        Text(
                          '방금 구매한 계란 5개씩 나누실 분...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('모구가 : 2000원'),
                        Text('참여 인원 2/3\n모구 마감 12/32'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '**신청 상태 : 승인',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyMoguCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PostDetailPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      splashColor: Colors.purple.withOpacity(0.3), // 물결 효과 색상
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.image, size: 60, color: Colors.grey), // 임시 이미지 아이콘
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '방금 구매한 계란 5개씩 나누실 분...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('모구가 : 2000원'),
                    Text('모구 마감: 2024/12/32'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('2/3'),
                        SizedBox(width: 8),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey,
                            ),
                            Positioned(
                              left: 12,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(posts[index]);
        },
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildChatFilterButton('전체'),
                SizedBox(width: 8),
                _buildChatFilterButton('판매'),
                SizedBox(width: 8),
                _buildChatFilterButton('구매'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatItems.length,
              itemBuilder: (context, index) {
                final chat = chatItems[index];
                return ListTile(
                  leading: Icon(
                    Icons.image, // 임시로 사용할 아이콘
                    size: 50, // 아이콘 크기
                    color: Colors.grey, // 아이콘 색상
                  ),
                  title: Text(chat['title']!),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: const [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            left: 8, // 겹치는 정도 조절, 이 값이 NaN이 아님을 확인
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(chat['time']!),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ChatRoomPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildMoguHistoryCard();
                  },
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildMyMoguCard();
            },
          ),
        ],
      ),
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                '모비짱',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '서울시 서대문구 남가좌동',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProfilePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey.shade200,
                ),
                child: Text('프로필 수정하기'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Column(
                    children: [
                      Text('레벨', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Text('10회', style: TextStyle(fontSize: 18, color: Colors.purple)),
                      SizedBox(height: 10),
                      Text('20회', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('매너도', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      Icon(Icons.favorite, color: Colors.pink),
                      Text('9.5', style: TextStyle(fontSize: 18, color: Colors.purple)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('나의 위치'),
                subtitle: Text('서울시 서대문구 남가좌동'),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('가입일'),
                subtitle: Text('2024/01/20'),
              ),
              ListTile(
                leading: Icon(Icons.money),
                title: Text('모구로 아낌비용'),
                subtitle: Text(
                  '25,600원',
                  style: TextStyle(fontSize: 20, color: Colors.pink),
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 0
            ? IconButton(
          icon: Icon(Icons.reorder),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    MenuPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        )
            : null, // 홈 화면이 아니면 leading을 null로 설정
        title: _selectedIndex == 0
            ? null
            : Text(
          ['채팅목록', '모구내역', '마이페이지'][_selectedIndex - 1],
          style: TextStyle(
            color: Color(0xFFFFD3F0),
            fontWeight: FontWeight.bold, // 글자 두껍게 설정
          ),
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
        bottom: _selectedIndex == 2
            ? PreferredSize(
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
              tabs: const [
                Tab(text: '나의 참여'),
                Tab(text: '나의 모구'),
              ],
            ),
          ),
        )
            : null,
        actions: [
          if (_selectedIndex == 0) // 홈 화면일 때만 검색 버튼을 표시
            IconButton(
              icon: Icon(Icons.search),
              color: Color(0xFFFFD3F0),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SearchPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          IconButton(
            icon: Icon(
              _selectedIndex == 3 ? Icons.settings : Icons.notifications,
            ),
            color: Color(0xFFFFD3F0),
            onPressed: () {
              if (_selectedIndex != 3) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        NotificationPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              } else {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('계정관리'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountManagementPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('환경설정'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('취소'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: _selectedIndex == 2
          ? TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildMoguHistoryCard();
                  },
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildMyMoguCard();
            },
          ),
        ],
      )
          : Column(
        children: <Widget>[
          if (_selectedIndex == 0 && _isAdLoaded) // 홈 화면일 때만 배너 광고 표시
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          if (_selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 왼쪽과 오른쪽에 요소 배치
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                        "assets/icons/search_filter.svg"
                    ),
                    onPressed: () {
                      _showSearchOptions(context); // 검색 옵션 모달 창을 띄움
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedSortOption,
                    items: _sortOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Color(0xFFB34FD1)),),
                      );
                    }).toList(),
                    onChanged: _onSortOptionChanged,
                    iconEnabledColor: Color(0xFFB34FD1),
                    underline: SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: widgetOptions[_selectedIndex], // 선택된 탭에 따라 다른 화면을 보여줌
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 0
                  ? "assets/icons/selected_home.svg"
                  : "assets/icons/unselected_home.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 1
                  ? "assets/icons/selected_chat.svg"
                  : "assets/icons/unselected_chat.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 2
                  ? "assets/icons/selected_history.svg"
                  : "assets/icons/unselected_history.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '모구내역',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 3
                  ? "assets/icons/selected_my_page.svg"
                  : "assets/icons/unselected_my_page.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: 'MY',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFB34FD1),
        unselectedItemColor: Color(0xFFFFBDE9),
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? ClipOval(
        child: Material(
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.3), // 물결 효과 색상
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostCreatePage(),
                ), // PostCreatePage로 이동
              );
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
          : null, // 홈 화면에서만 플로팅 액션 버튼을 표시
    );
  }
}



