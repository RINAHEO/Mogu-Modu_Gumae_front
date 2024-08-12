import 'package:flutter/material.dart';
import 'package:mogu_app/firstStep/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  void _showSignUpSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입 완료'),
          content: Text('회원가입이 완료되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        LoginPage(),
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
              child: Text('확인', style: TextStyle(color: Color(0xFFB34FD1))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // 그림자 제거
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFB34FD1)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24),
              _buildTextFieldWithLabel("아이디 (이메일주소)", true),
              SizedBox(height: 16),
              _buildTextFieldWithLabel("패스워드", true),
              SizedBox(height: 16),
              _buildDropDownField("성별", true),
              SizedBox(height: 16),
              _buildTextFieldWithLabel("이름", true),
              SizedBox(height: 16),
              _buildTextFieldWithLabel("핸드폰번호", true),
              SizedBox(height: 16),
              _buildTextFieldWithLabel("나의지역", true),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: () {
              _showSignUpSuccessDialog(); // 확인 버튼 클릭 시 다이얼로그 표시
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB34FD1), // 버튼 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 모서리 둥글게
              ),
            ),
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(String labelText, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: labelText,
            style: TextStyle(
              color: Colors.grey[700], // 회색 빛 텍스트
              fontSize: 16,
              fontWeight: FontWeight.w500, // 중간 굵기
            ),
            children: isRequired
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Color(0xFFB34FD1), // 보라색 별표
                  fontSize: 16,
                ),
              ),
            ]
                : [],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB34FD1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropDownField(String labelText, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: labelText,
            style: TextStyle(
              color: Colors.grey[700], // 회색 빛 텍스트
              fontSize: 16,
              fontWeight: FontWeight.w500, // 중간 굵기
            ),
            children: isRequired
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Color(0xFFB34FD1), // 보라색 별표
                  fontSize: 16,
                ),
              ),
            ]
                : [],
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          items: const [
            DropdownMenuItem(
              value: "male",
              child: Text("남성"),
            ),
            DropdownMenuItem(
              value: "female",
              child: Text("여성"),
            ),
          ],
          onChanged: (value) {
            // 선택한 값 처리
          },
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB34FD1)),
            ),
          ),
        ),
      ],
    );
  }
}


