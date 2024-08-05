import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Column(
            children: [
              Expanded(
                child: Container(
                  width: screenWidth,
                  height: screenHeight,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: screenWidth,
                          height: screenHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.71, -0.71),
                              end: Alignment(-0.71, 0.71),
                              colors: [Color(0xFFFFA7E1), Color(0xB29322CC)],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.05,
                        top: screenHeight * 0.55,
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.25,
                          child: Column(
                            children: [
                              _buildButton('카카오톡으로 로그인', () {}),
                              SizedBox(height: screenHeight * 0.01),
                              _buildButton('구글로 로그인', () {}),
                              SizedBox(height: screenHeight * 0.01),
                              _buildButton('로그인으로 시작하기', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: (screenWidth - 113) / 2,
                        top: screenHeight * 0.3,
                        child: Container(
                          width: 113,
                          height: 104,
                          child: Image.asset(
                            'assets/Mogulogo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 140, // 하단 여백
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TermsandPolicy()),
                              );
                            },
                            child: Text(
                              '회원가입하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFFFFD3F0), // 배경색을 투명으로 설정
        minimumSize: Size(double.infinity, 58), // 버튼 크기를 Container에 맞추기
        padding: EdgeInsets.zero, // 기본 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Container와 같은 모서리 둥글기
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFFB34FD1),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class TermsandPolicy extends StatefulWidget {
  const TermsandPolicy({super.key});

  @override
  _TermsandPolicyState createState() => _TermsandPolicyState();
}

class _TermsandPolicyState extends State<TermsandPolicy> {
  List<bool> _isChecked = List.generate(5, (_) => false);
  bool get _buttonActive =>
      _isChecked.sublist(1, 4).every((element) => element);

  void _updateCheckState(int index, bool? value) {
    setState(() {
      if (index == 0) {
        bool isAllChecked = !_isChecked.every((element) => element);
        _isChecked = List.generate(5, (i) => isAllChecked);
      } else {
        _isChecked[index] = value ?? false;
        bool allChecked = _isChecked.sublist(1, 5).every((element) => element);
        _isChecked[0] = allChecked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.all(20),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: '안녕하세요!\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '약관동의',
                        style: TextStyle(
                          color: Color(0xFF9932CC),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '가 필요해요',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.5, // 줄 간격 조정
                        ),
                      ),
                    ]),
                  )),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xFF908D8D)),
                        ),
                      ),
                      child: _buildCheckboxWithText(
                          '전체동의',
                          _isChecked[0],
                          (value) => _updateCheckState(0, value),
                          Color(0xFF9932CC)),
                    ),
                    const SizedBox(height: 13),
                    _buildCheckboxWithText('[필수] 모구 이용 약관 동의', _isChecked[1],
                        (value) => _updateCheckState(1, value), Colors.black),
                    _buildCheckboxWithText('[필수] 개인정보 처리 방침 동의', _isChecked[2],
                        (value) => _updateCheckState(2, value), Colors.black),
                    _buildCheckboxWithText(
                        '[필수] 개인정보 제 3자 제공 동의',
                        _isChecked[3],
                        (value) => _updateCheckState(3, value),
                        Colors.black),
                    _buildCheckboxWithText('[선택] 광고, 혜택 수신 동의', _isChecked[4],
                        (value) => _updateCheckState(4, value), Colors.black),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        _buttonActive ? Color(0xFFB34FD1) : Colors.grey,
                    minimumSize: Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _buttonActive
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        }
                      : null,
                  child: Text(
                    '동의하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 13),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxWithText(String text, bool isChecked,
      ValueChanged<bool?> onChanged, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17.0),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              checkColor: Color(0xFFB34FD1),
              fillColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return Colors.transparent; // 체크박스 배경색을 투명하게 설정
                },
              ),
              value: isChecked,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
