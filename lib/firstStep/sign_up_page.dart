import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mogu_app/firstStep/login_page.dart';

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
  NaverMapController? _mapController;
  late NLatLng currentPosition;

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPosition = NLatLng(position.latitude, position.longitude);
    });
  }

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
            "longitude": currentPosition.longitude.toString(),
            "latitude": currentPosition.latitude.toString()
          }),
        );

        if (response.statusCode == 201) {
          print('회원가입 성공');
          _showSignUpSuccessDialog();
        } else {
          print('회원가입 실패: ${response.statusCode}');
          _showErrorDialog('회원가입 실패', '서버에서 오류가 발생했습니다.');
        }
      } catch (e) {
        print('회원가입 오류: $e');
        _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.');
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('확인', style: TextStyle(color: Color(0xFFB34FD1))),
            ),
          ],
        );
      },
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

  void _verifyEmail() {
    final email = userIdController.text;
    final emailRegExp = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (email.isEmpty || !emailRegExp.hasMatch(email)) {
      _showErrorDialog('오류', '유효한 이메일 주소를 입력해주세요');
    } else {
      setState(() {
        isVerificationFieldVisible = true;
      });
      _showErrorDialog('인증번호 발송', '이메일 인증번호를 발송했습니다.');
      print('이메일 인증 로직 실행');
    }
  }

  void _confirmVerificationCode() {
    // 인증번호 확인 로직을 여기 추가하세요
    print('인증번호 확인 로직 실행');
  }

  Future<void> _onLocationIconPressed() async {
    final NLatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('위치 선택'),
          ),
          body: NaverMap(
            onMapReady: (controller) async {
              _mapController = controller;
              moveToLocation(_mapController!, currentPosition.latitude, currentPosition.longitude);
              final marker = NMarker(id: 'currentPosition_marker', position: currentPosition);
              final onMarkerInfoWindow = NInfoWindow.onMarker(id: 'currentPosition_marker_info', text: "내 위치");
              _mapController!.addOverlay(marker);
              marker.openInfoWindow(onMarkerInfoWindow);
            },
            onMapTapped: (point, latLng) {
              Navigator.pop(context, latLng);
            },
            onSymbolTapped: (symbol){
              Navigator.pop(context, symbol.position);
            },
          ),
        ),
      ),
    );

    if (selectedLocation != null) {
      String currentAddress = await getAddressFromCoordinates(selectedLocation.latitude, selectedLocation.longitude);
      setState(() {
        nicknameController.text = currentAddress;
      });
    }
  }

  void moveToLocation(NaverMapController controller, double latitude, double longitude) async {
    NCameraUpdate cameraUpdate = NCameraUpdate.fromCameraPosition(
        NCameraPosition(target: NLatLng(latitude, longitude), zoom: 15)
    );
    await controller.updateCamera(cameraUpdate);
  }

  double truncateCoordinate(double coord, {int precision = 3}) {
    double mod = pow(10.0, precision).toDouble();
    return ((coord * mod).round().toDouble() / mod);
  }

  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    String apiKey = dotenv.env['VWORLD_API_KEY'] ?? 'API_KEY_NOT_FOUND';

    latitude = truncateCoordinate(latitude, precision: 3);
    longitude = truncateCoordinate(longitude, precision: 3);

    String baseUrl =
        'https://api.vworld.kr/req/address?service=address&request=getAddress&key=$apiKey&point=';

    try {
      for (int i = 0; i < 10; i++) {
        String url = '$baseUrl$longitude,$latitude&type=ROAD';
        print('Sending request to: $url');
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);

          if (jsonResponse['response'] != null && jsonResponse['response']['status'] == 'OK') {
            var results = jsonResponse['response']['result'];
            if (results != null && results.isNotEmpty) {
              var address = results[0]['text'];
              print('Address found: $address');
              return address;
            }
          }
        }

        latitude += 0.001;
        longitude += 0.001;
      }

      return '알 수 없는 위치';
    } catch (e) {
      print('Exception caught: $e');
      return '네트워크 오류가 발생했습니다';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFB34FD1)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,  // 배경색을 흰색으로 설정
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
              backgroundColor: Color(0xFFB34FD1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
            backgroundColor: Color(0xFFB34FD1),
            minimumSize: Size(150, 50),
          ),
          child: Text(
            '이메일 인증하기',
            style: TextStyle(color: Colors.white),
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
            backgroundColor: Color(0xFFB34FD1),
            minimumSize: Size(150, 50),
          ),
          child: Text(
            '인증번호 확인',
            style: TextStyle(color: Colors.white),
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
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Color(0xFFB34FD1),
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
              if (value.length != 13) {
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