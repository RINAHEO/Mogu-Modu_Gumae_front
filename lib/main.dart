import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/home_page.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() {
  initialize();
  runApp(const MoguApp());
}

void initialize(){
  WidgetsFlutterBinding.ensureInitialized();
  NaverMapSdk.instance.initialize(
    clientId: '5976phb2xh',
  );
}

class MoguApp extends StatelessWidget {
  const MoguApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: HomePage(),
    );
  }
}
