import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({super.key});

  @override
  _PostCreatePageState createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final int maxImages = 3;
  final List<Uint8List> _selectedImages = [];
  final TextEditingController priceController = TextEditingController();
  final TextEditingController personController = TextEditingController();
  String discountPrice = '0 원';
  String selectedCategory = '식료품';
  String purchaseStatus = '구매 예정';
  DateTime selectedDate = DateTime.now();
  String meetingPlace = '구매를 위해 모일 장소';
  NaverMapController? _mapController;
  late NLatLng currentPosition;

  @override
  void initState() {
    super.initState();
    priceController.addListener(_updatePrice);
    personController.addListener(_updatePerson);
    _requestPermissions(context).then((_) {
      _initCurrentLocation();
    });
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

  Future<void> _requestPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.camera,
      // Permission.storage,
      Permission.location,
    ].request();

    if (statuses.values.every((status) => status.isDenied)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.'),
          action: SnackBarAction(
            label: '설정으로 이동',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    } else if (statuses.values.every((status) => status.isGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 권한이 허용되었습니다. ')),
      );
    } else if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('일부 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.'),
          action: SnackBarAction(
            label: '설정으로 이동',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일부 권한이 허용되었습니다. 설정에서 권한을 허용해주세요.'),
          action: SnackBarAction(
            label: '설정으로 이동',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }
  }

  void _updatePrice() {
    final text = priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isNotEmpty) {
      priceController.value = priceController.value.copyWith(
        text: '$text 원',
        selection: TextSelection.collapsed(offset: text.length),
      );
      _calculateDiscount();
    }
  }

  void _updatePerson() {
    final text = personController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isNotEmpty) {
      personController.value = personController.value.copyWith(
        text: '$text 명',
        selection: TextSelection.collapsed(offset: text.length),
      );
      _calculateDiscount();
    }
  }

  void _calculateDiscount() {
    final priceText = priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    final personText = personController.text.replaceAll(RegExp(r'[^\d]'), '');

    if (priceText.isNotEmpty && personText.isNotEmpty) {
      final price = int.tryParse(priceText) ?? 0;
      final person = int.tryParse(personText) ?? 1;
      final discount = person > 0 ? (price / person).floor() : 0;

      setState(() {
        discountPrice = '$discount 원';
      });
    } else {
      setState(() {
        discountPrice = '0 원';
      });
    }
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('최대 $maxImages개의 이미지만 업로드할 수 있습니다.')),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      Uint8List fileBytes = await file.readAsBytes();

      setState(() {
        _selectedImages.add(fileBytes);
      });
    }
  }

  void _selectCategory() async {
    final category = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              title: Text('식료품'),
              onTap: () => Navigator.pop(context, '식료품'),
            ),
            ListTile(
              title: Text('일회용품'),
              onTap: () => Navigator.pop(context, '일회용품'),
            ),
            ListTile(
              title: Text('청소용품'),
              onTap: () => Navigator.pop(context, '청소용품'),
            ),
            ListTile(
              title: Text('뷰티/미용'),
              onTap: () => Navigator.pop(context, '뷰티/미용'),
            ),
            ListTile(
              title: Text('취미/게임'),
              onTap: () => Navigator.pop(context, '취미/게임'),
            ),
            ListTile(
              title: Text('생활/주방'),
              onTap: () => Navigator.pop(context, '생활/주방'),
            ),
            ListTile(
              title: Text('육아용품'),
              onTap: () => Navigator.pop(context, '육아용품'),
            ),
            ListTile(
              title: Text('기타'),
              onTap: () => Navigator.pop(context, '기타'),
            ),
            ListTile(
              title: Text('무료 나눔'),
              onTap: () => Navigator.pop(context, '무료 나눔'),
            ),
          ],
        );
      },
    );

    if (category != null) {
      setState(() {
        selectedCategory = category;
      });
    }
  }

  void _selectPurchaseStatus() async {
    final status = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              title: Text('구매 예정'),
              onTap: () => Navigator.pop(context, '구매 예정'),
            ),
            ListTile(
              title: Text('구매 완료'),
              onTap: () => Navigator.pop(context, '구매 완료'),
            ),
          ],
        );
      },
    );

    if (status != null) {
      setState(() {
        purchaseStatus = status;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
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
    String apiKey = '92847C2D-0B70-3586-8343-66FF39FB047E';

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

        // If address not found, adjust the coordinates slightly
        latitude += 0.001;
        longitude += 0.001;
      }

      // Fallback address if no valid address is found
      return '알 수 없는 위치';
    } catch (e) {
      print('Exception caught: $e');
      return '네트워크 오류가 발생했습니다';
    }
  }

  Future<void> _selectLocation() async {
    final NLatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('모일 위치 선택'),
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
        meetingPlace = currentAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context);
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '제목',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내용',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('사진등록', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40),
                        SizedBox(height: 4),
                        Text('${_selectedImages.length}/$maxImages'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _selectedImages
                          .map((imageData) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            imageData,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailRow('상품 카테고리', selectedCategory, _selectCategory),
            _buildDetailRow('상품 구매', purchaseStatus, _selectPurchaseStatus),
            _buildDetailRow('마감 기한',
                DateFormat('yyyy/MM/dd').format(selectedDate), _selectDate),
            _buildPriceInputRow('상품 구매 가격', priceController),
            _buildPersonInputRow('모구 인원', personController),
            _buildDetailRow('할인된 가격', discountPrice, null, false),
            _buildDetailRow('모임 장소', meetingPlace, _selectLocation),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            print('등록하기 버튼이 눌렸습니다!');
          },
          child: Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.only(top: 9, left: 11, right: 12, bottom: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14737373),
                  blurRadius: 4,
                  offset: Offset(0, -4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Material(
                    color: Color(0xFFB34FD1),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        print('등록하기 버튼이 눌렸습니다!');
                      },
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            '등록하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value,
      [VoidCallback? onTap, bool showArrow = true]) {
    IconData? icon = showArrow && onTap != null ? Icons.arrow_drop_down : null;

    if (title == '모임 장소') {
      icon = Icons.place;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                if (icon != null && title == '모임 장소')
                  Icon(
                    icon,
                    color: Color(0xFFB34FD1),
                  ),
                if (title == '모임 장소')
                  SizedBox(width: 4), // Add space between icon and text
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFB34FD1),
                  ),
                ),
                if (icon != null && title != '모임 장소')
                  Icon(
                    icon,
                    color: Color(0xFFB34FD1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInputRow(
      String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Container(
            width: 150,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '0 원',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFB34FD1),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonInputRow(
      String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Container(
            width: 150,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
              ],
              decoration: InputDecoration(
                hintText: '0 명',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFB34FD1),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




