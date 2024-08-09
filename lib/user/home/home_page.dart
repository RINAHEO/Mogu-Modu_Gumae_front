import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mogu_app/user/home/post/post_create_page.dart';

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

  // 각 탭에서 표시할 위젯들을 정의
  static final List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('홈 화면')),
    Center(child: Text('채팅 화면')),
    Center(child: Text('모구내역 화면')),
    Center(child: Text('MY 화면')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 0
            ? IconButton(
          icon: Icon(Icons.reorder),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            // 리오더 아이콘을 눌렀을 때 실행될 동작을 정의하세요.
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
              colors: [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
        actions: [
          if (_selectedIndex == 0) // 홈 화면일 때만 검색 버튼을 표시
            IconButton(
              icon: Icon(Icons.search),
              color: Color(0xFFFFD3F0),
              onPressed: () {
                // 검색 버튼을 눌렀을 때 실행될 동작을 정의하세요.
              },
            ),
          IconButton(
            icon: Icon(
              _selectedIndex == 3 ? Icons.settings : Icons.notifications,
            ),
            color: Color(0xFFFFD3F0),
            onPressed: () {
              // 알림 또는 설정 버튼을 눌렀을 때 실행될 동작을 정의하세요.
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (_isAdLoaded)
            Container(
              alignment: Alignment.center,
              child: AdWidget(ad: _bannerAd!),
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
            ),
          Expanded(
            child: _widgetOptions[_selectedIndex], // 선택된 탭에 따라 다른 화면을 보여줌
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
      floatingActionButton: ClipOval(
        child: Material(
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.3), // 물결 효과 색상
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostCreatePage()), // PostCreatePage로 이동
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
      ),
    );
  }
}


