import 'package:flutter/material.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  String _nickname = '모비짱'; // 초기 닉네임
  String _address = '서울시 서대문구 남가좌동'; // 초기 주소
  final String _profileImageUrl = ''; // 프로필 이미지 URL (초기값은 비어 있음)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFE9F8),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 돌아가기
          },
        ),
        title: Text(
          '프로필수정',
          style: TextStyle(
            color: Color(0xFFFFE9F8),
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
              colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // 프로필 사진 변경 로직 추가 (갤러리에서 선택하거나 카메라로 찍기)
                    // 예시: showDialog를 사용하여 선택 옵션 제공
                  },
                  child: CircleAvatar(
                    radius: 40, // 프로필 사진 크기를 키움
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _profileImageUrl.isNotEmpty
                        ? NetworkImage(_profileImageUrl)
                        : null,
                    child: _profileImageUrl.isEmpty
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _editNickname(); // 텍스트 필드를 클릭 시 닉네임 변경 다이얼로그를 호출합니다.
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5), // 레디우스 수치를 낮게 설정
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight, // 텍스트 오른쪽 정렬
                              child: Text(
                                _nickname,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8), // 텍스트와 아이콘 사이에 여백 추가
                          Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 20, // 아이콘 크기 조정
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 주소 변경 텍스트 필드
            TextField(
              controller: TextEditingController(text: _address),
              decoration: InputDecoration(
                labelText: '주소',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.edit_location),
              ),
              onChanged: (value) {
                setState(() {
                  _address = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveProfileChanges();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40), // 버튼의 높이를 줄임
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 사각형에 둥근 모서리
                ),
              ),
              child: Text('수정완료'),
            ),
          ],
        ),
      ),
    );
  }

  void _editNickname() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(text: _nickname);
        return AlertDialog(
          title: Text('닉네임 변경'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "새 닉네임을 입력하세요"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _nickname = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _saveProfileChanges() {
    // 변경된 프로필 정보를 저장하는 로직 추가
    // 예를 들어, 서버로 데이터 전송 등을 수행할 수 있습니다.
    Navigator.pop(context); // 저장 후 페이지 닫기
  }
}




