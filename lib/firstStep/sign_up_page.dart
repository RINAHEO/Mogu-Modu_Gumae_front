import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mogu_app/firstStep/login_page.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isVerificationFieldVisible = false;

  Future<void> postUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String userId = userIdController.text;
      String password = passwordController.text;
      String name = nameController.text;
      String nickname = nicknameController.text;
      String phone = phoneController.text;

      String url = 'http://localhost:8080/user';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "userId": userId,
            "password": password,
            "name": name,
            "nickname": nickname,
            "phone": phone,
            "role": "user",
            "longitude": "-122.4194",
            "latitude": "37.7749"
          }),
        );

        if (response.statusCode == 201) {
          print('공지 등록 성공');
          _showSignUpSuccessDialog();
        } else {
          print('공지 등록 실패: ${response.statusCode}');
          // Show the error message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('오류'),
                content: Text("제목, 내용을 채워 주세요."),
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
      } catch (e) {
        print('공지 등록 오류: $e');
        // Show a general error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('오류'),
              content: Text('서버와의 연결 오류가 발생했습니다.'),
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
    }
  }

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

  void _verifyEmail() {
    final email = userIdController.text;
    final emailRegExp = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (email.isEmpty || !emailRegExp.hasMatch(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('유효한 이메일 주소를 입력해주세요'),
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
    } else {
      setState(() {
        isVerificationFieldVisible = true;
      });
      // 이메일 인증번호 발송 로직을 여기 추가하세요
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('인증번호 발송'),
            content: Text('이메일 인증번호를 발송했습니다.'),
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
      print('이메일 인증 로직 실행');
    }
  }

  void _confirmVerificationCode() {
    // 인증번호 확인 로직을 여기 추가하세요
    print('인증번호 확인 로직 실행');
  }

  void _onLocationIconPressed() {
    // 로케이션 아이콘 클릭 시 실행될 로직을 여기에 추가하세요
    print('로케이션 아이콘 클릭됨');
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
          child: Form(
            key: _formKey,
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
                _buildUserIdField(),
                if (isVerificationFieldVisible) ...[
                  SizedBox(height: 16),
                  _buildVerificationCodeField(),
                ],
                SizedBox(height: 16),
                _buildTextFieldWithLabel(
                    "패스워드", true, "패스워드를 입력하세요", passwordController),
                SizedBox(height: 16),
                _buildTextFieldWithLabel("이름", true, "이름을 입력하세요", nameController),
                SizedBox(height: 16),
                _buildPhoneNumberField(),
                SizedBox(height: 16),
                _buildLocationField(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: () {
              postUser(context);
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

  Widget _buildUserIdField() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFieldWithLabel(
              "아이디 (이메일주소)", true, "이메일을 입력하세요", userIdController),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: _verifyEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB34FD1), // 버튼 색상
            minimumSize: Size(150, 50), // 버튼 길이 설정
          ),
          child: Text(
            '이메일 인증하기',
            style: TextStyle(color: Colors.white), // 하얀색 텍스트
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationCodeField() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFieldWithLabel(
            "인증번호 입력",
            true,
            "인증번호를 입력하세요",
            verificationCodeController,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: _confirmVerificationCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB34FD1), // 버튼 색상
            minimumSize: Size(150, 50), // 버튼 길이 설정
          ),
          child: Text(
            '인증번호 확인',
            style: TextStyle(color: Colors.white), // 하얀색 텍스트
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return _buildTextFieldWithLabel(
      "핸드폰번호",
      true,
      "핸드폰 번호를 입력하세요",
      phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
        PhoneNumberFormatter(),
      ],
    );
  }

  Widget _buildLocationField() {
    return _buildTextFieldWithLabel(
      "나의지역",
      true,
      "지역을 입력하세요",
      nicknameController,
      suffixIcon: IconButton(
        icon: Icon(Icons.location_on, color: Color(0xFFB34FD1)),
        onPressed: _onLocationIconPressed,
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
      String labelText,
      bool isRequired,
      String hintText,
      TextEditingController controller, {
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
        Widget? suffixIcon,
      }) {
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB34FD1)),
            ),
            errorStyle: TextStyle(color: Colors.red),
            suffixIcon: suffixIcon,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$labelText를 입력해주세요';
            }
            if (labelText == "아이디 (이메일주소)") {
              final emailRegExp = RegExp(
                  r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
              if (!emailRegExp.hasMatch(value)) {
                return '유효한 이메일 주소를 입력해주세요';
              }
            } else if (labelText == "패스워드") {
              if (value.length < 8 || value.length > 16) {
                return '패스워드는 8자에서 16자 사이여야 합니다';
              }
            } else if (labelText == "이름" || labelText == "나의지역") {
              if (value.length > 12) {
                return '$labelText는 최대 12자까지 입력할 수 있습니다';
              }
            } else if (labelText == "핸드폰번호") {
              if (value.length != 13) { // 하이픈 포함 13자
                return '핸드폰 번호는 11자리여야 합니다';
              }
              final phoneRegExp = RegExp(r'^\d{3}-\d{4}-\d{4}$');
              if (!phoneRegExp.hasMatch(value)) {
                return '유효한 핸드폰 번호를 입력해주세요';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}

// 전화번호 형식 맞춤 포맷터
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length > 3 && text.length <= 7) {
      final formattedText = '${text.substring(0, 3)}-${text.substring(3)}';
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    } else if (text.length > 7 && text.length <= 11) {
      final formattedText = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}';
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
    return newValue;
  }
}