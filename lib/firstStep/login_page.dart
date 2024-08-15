import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty) {
      _showErrorDialog('오류', '아이디를 입력해주세요');
      return;
    }

    if (password.isEmpty) {
      _showErrorDialog('오류', '패스워드를 입력해주세요');
      return;
    }

    String loginUrl = 'http://10.0.2.2:8080/login?username=$username&password=$password';

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        String? token = response.headers['authorization'];
        if (token != null) {
          await _saveToken(token);
          final userInfo = await _getUserInfo(username, token);
          if (userInfo != null) {
            userInfo['token'] = token;  // 토큰을 userInfo에 추가
            _navigateToHomePage(userInfo);
          } else {
            _showErrorDialog('오류', '유저 정보를 가져올 수 없습니다.');
          }
        } else {
          _showErrorDialog('로그인 실패', '토큰을 찾을 수 없습니다.');
        }
      } else {
        print(response.statusCode);
        _showErrorDialog('로그인 실패', '로그인 정보를 확인해주세요.');
      }
    } catch (e) {
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<Map<String, dynamic>?> _getUserInfo(String username, String token) async {
    String userUrl = 'http://10.0.2.2:8080/user/$username';

    try {
      final response = await http.get(
        Uri.parse(userUrl),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load user info. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return null;
    }
  }

  void _navigateToHomePage(Map<String, dynamic> userInfo) {
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(userInfo: userInfo),
      ),
    );
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Color(0xFFFFA7E1).withOpacity(0.8),
          elevation: 0, // 그림자 제거
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        return Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.71, -0.71),
              end: Alignment(-0.71, 0.71),
              colors: [
                Color(0xFFFFA7E1).withOpacity(0.8),
                Color(0xB29322CC).withOpacity(0.6),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: (screenWidth - 113) / 2,
                top: screenHeight * 0.12,
                child: SizedBox(
                  width: 113,
                  height: 104,
                  child: Image.asset(
                    'assets/Mogulogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.4,
                left: 0,
                right: 0,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.70,
                        child: Container(
                          width: 320,
                          height: 58,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: usernameController,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '아이디 (이메일)',
                              hintStyle: TextStyle(
                                color: Color(0xFF908D8D),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Opacity(
                        opacity: 0.70,
                        child: Container(
                          width: 320,
                          height: 58,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '패스워드',
                              hintStyle: TextStyle(
                                color: Color(0xFF908D8D),
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 320,
                        height: 58,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFB34FD1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            login(context);
                          },
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
