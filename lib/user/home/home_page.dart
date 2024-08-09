import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mogu_app/user/home/post/post_create_page.dart';
import 'package:mogu_app/user/home/search_page.dart';
import 'package:mogu_app/user/myPage/account_management_page.dart';

import '../myPage/setting_page.dart';
import '../myPage/update_profile_page.dart';
import 'menu_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
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

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      Center(child: Text('홈 화면')),
      Center(child: Text('채팅 화면')),
      Center(child: Text('모구내역 화면')),
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
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0); // 왼쪽에서 시작
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
                    transitionsBuilder: (context, animation, secondaryAnimation,
                        child) {
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
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
      body: Column(
        children: <Widget>[
          if (_selectedIndex == 0 && _isAdLoaded) // 홈 화면일 때만 배너 광고 표시
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
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


