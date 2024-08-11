import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // 최근 검색어 리스트
  List<String> recentSearches = ['최근 검색 1', '최근 검색 2', '최근 검색 3'];

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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.68, -0.73),
              end: Alignment(-0.68, 0.73),
              colors: [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // 패딩 조정
          child: Container(
            height: 35, // 핑크색 부분의 높이 조정
            decoration: BoxDecoration(
              color: Color(0xFFFFBDE9),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20), // 좌우 패딩
                      isDense: true, // 밀집된 형태로 만들기
                    ),
                  ),
                ),
                Padding(
                  // 여기에 패딩 추가
                  padding: const EdgeInsets.only(right: 8.0), // 오른쪽 패딩 조정
                  child: IconButton(
                    icon: Icon(Icons.search),
                    color: Color(0xFFFFD3F0),
                    padding: EdgeInsets.zero, // 기본 패딩 제거
                    constraints: BoxConstraints(), // 아이콘의 크기 조정
                    onPressed: () {
                      // 이 버튼을 눌렀을 때 실행될 동작을 정의하세요.
                      print('Search button pressed');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '최근 검색어',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: recentSearches.map((search) {
                return Chip(
                  label: Text(search),
                  onDeleted: () {
                    setState(() {
                      recentSearches.remove(search); // 삭제
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              '실시간 인기 검색어',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                Chip(
                  label: Text('계란'),
                  backgroundColor: Colors.grey.shade200,
                ),
                Chip(
                  label: Text('물티슈'),
                  backgroundColor: Colors.grey.shade200,
                ),
                Chip(
                  label: Text('도떼기시장'),
                  backgroundColor: Colors.grey.shade200,
                ),
              ],
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '최근에 ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextSpan(
                    text: '물티슈',
                    style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextSpan(
                    text: '를 검색했어요! 나를 위한 추천 구매',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildProductCard(
              context,
              '김찬',
              '1~2km',
              '방금 구매한 물티슈 1개씩 나눌 분...',
              '2000원',
              '10% 더 싸요',
              '모구 12/32',
              '7',
              '23',
            ),
            _buildProductCard(
              context,
              '나허리',
              '500m 미만',
              '~~위치에 물티슈 10개에 6000원 할인하고 있습니다!',
              '2000원',
              '10% 더 싸요',
              '모구 12/32',
              '7',
              '23',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context,
      String userName,
      String distance,
      String title,
      String price,
      String discount,
      String mogooPeople,
      String likes,
      String views,
      ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(distance, style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.grey.shade300,
                      width: 70,
                      height: 70,
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.favorite_border, color: Colors.purple, size: 16),
                        SizedBox(width: 4),
                        Text(likes, style: TextStyle(color: Colors.purple)),
                        SizedBox(width: 16),
                        Icon(Icons.visibility, color: Colors.purple, size: 16),
                        SizedBox(width: 4),
                        Text(views, style: TextStyle(color: Colors.purple)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFBDE9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('모구', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Text(
                  price,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFB34FD1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(discount, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(mogooPeople, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

