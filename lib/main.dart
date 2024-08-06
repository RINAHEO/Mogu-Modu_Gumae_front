import 'package:flutter/material.dart';
import 'admin/complaint/notice_create_page.dart';
import 'firstStep/loading_page.dart';

void main() {
  runApp(const MoguApp());
}

class MoguApp extends StatelessWidget {
  const MoguApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    // home: LoadingPage(),
      home: NoticeCreatePage(),
    );
  }
}
