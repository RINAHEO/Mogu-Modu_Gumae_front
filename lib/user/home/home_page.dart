import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 각 페이지에 대한 임포트 추가
import 'package:mogu_app/user/home/post/post_create_page.dart';
import 'package:mogu_app/user/chat/chat_list_page.dart'; // 채팅 페이지 임포트
import 'package:mogu_app/user/history/history_list_page.dart'; // 모구내역 페이지 임포트
import 'package:mogu_app/user/mypage/myPage_page.dart'; // MY 페이지 임포트

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   BannerAd? _bannerAd;
//   bool _isAdLoaded = false;
//   int _selectedIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBannerAd();
//   }
//
//   void _loadBannerAd() {
//     _bannerAd = BannerAd(
//       // adUnitId: 'ca-app-pub-8290073486354091/8638791624', // 실제 광고
//       adUnitId: 'ca-app-pub-3940256099942544/9214589741', // 배너 광고 테스트 ID
//       size: AdSize.banner,
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           print('Failed to load a banner ad: $error');
//           ad.dispose();
//         },
//       ),
//     );
//
//     _bannerAd!.load();
//   }
//
//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }
//
//   Widget _getIcon(int index, String selectedIconPath, String unselectedIconPath) {
//     return SvgPicture.asset(
//       _selectedIndex == index ? selectedIconPath : unselectedIconPath,
//       width: 24,
//       height: 24,
//       fit: BoxFit.contain,
//     );
//   }
//
//   void _onNavItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     // 네비게이션 로직
//     switch (index) {
//       case 0:
//       // 홈 화면 (현재 화면이므로 아무것도 하지 않음)
//         break;
//       case 1:
//       // 채팅 페이지로 이동
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ChatListPage()),
//         );
//         break;
//       case 2:
//       // 모구내역 페이지로 이동
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HistoryListPage()),
//         );
//         break;
//       case 3:
//       // MY 페이지로 이동
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => MypagePage()),
//         );
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.reorder),
//           color: Color(0xFFFFE9F8),
//           onPressed: () {
//             // 이 버튼을 눌렀을 때 실행될 동작을 정의하세요.
//           },
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment(0.68, -0.73),
//               end: Alignment(-0.68, 0.73),
//               colors: [Color(0xFFFFA7E1), Color(0xB29322CC)],
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             color: Color(0xFFFFE9F8),
//             onPressed: () {
//               // 이 버튼을 눌렀을 때 실행될 동작을 정의하세요.
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.notifications),
//             color: Color(0xFFFFE9F8),
//             onPressed: () {
//               // 이 버튼을 눌렀을 때 실행될 동작을 정의하세요.
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           if (_isAdLoaded)
//             Container(
//               alignment: Alignment.center,
//               child: AdWidget(ad: _bannerAd!),
//               width: _bannerAd!.size.width.toDouble(),
//               height: _bannerAd!.size.height.toDouble(),
//             ),
//           Expanded(
//             child: Center(
//               child: Text('Main Content'),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           height: 64,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildNavItem(0, '홈', "assets/icons/selected_home.svg", "assets/icons/unselected_home.svg"),
//               _buildNavItem(1, '채팅', "assets/icons/selected_chat.svg", "assets/icons/unselected_chat.svg"),
//               _buildNavItem(2, '모구내역', "assets/icons/selected_history.svg", "assets/icons/unselected_history.svg"),
//               _buildNavItem(3, 'MY', "assets/icons/selected_my_page.svg", "assets/icons/unselected_my_page.svg"),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: ClipOval(
//         child: Material(
//           child: InkWell(
//             splashColor: Colors.white.withOpacity(0.3), // 물결 효과 색상
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => PostCreatePage()), // PostCreatePage로 이동
//               );
//             },
//             child: SizedBox(
//               width: 56,
//               height: 56,
//               child: Center(
//                 child: SvgPicture.asset(
//                   "assets/icons/post_create_button.svg",
//                   width: 56,
//                   height: 56,
//                   fit: BoxFit.contain,
//                   alignment: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem(int index, String label, String selectedIconPath, String unselectedIconPath) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => _onNavItemTapped(index), // 해당 버튼이 선택되었음을 표시하고 페이지로 이동
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _getIcon(index, selectedIconPath, unselectedIconPath),
//             Text(
//               label,
//               style: TextStyle(
//                 color: _selectedIndex == index ? Color(0xFFB34FD1) : Color(0xFFFFBDE9),
//                 fontSize: 9,
//                 fontFamily: 'Inter',
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//todo:ui 비교해서 선택하기
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
        // title: Text(['홈', '채팅', '모구내역', 'MY'][_selectedIndex]),
        leading: _selectedIndex == 0
            ? IconButton(
          icon: Icon(Icons.reorder),
          color: Color(0xFFFFE9F8),
          onPressed: () {
            // 리오더 아이콘을 눌렀을 때 실행될 동작을 정의하세요.
          },
        )
            : null, // 홈 화면이 아니면 leading을 null로 설정
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
          if (_selectedIndex == 0)
            IconButton(
              icon: Icon(Icons.search),
              color: Color(0xFFFFE9F8),
              onPressed: () {
                // 검색 버튼을 눌렀을 때 실행될 동작을 정의하세요.
              },
            ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Color(0xFFFFE9F8),
            onPressed: () {
              // 알림 버튼을 눌렀을 때 실행될 동작을 정의하세요.
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


