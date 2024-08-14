import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'first_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirstPage()),
        );
      });
    });
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.camera,
      // Permission.storage,
      Permission.location,
    ].request();

    statuses.forEach((permission, status) {
      if (status.isPermanentlyDenied) {
        print('${permission.toString()} 권한이 영구적으로 거부되었습니다.');
      }
    });

    if (statuses.values.every((status) => status.isDenied)) {
      // 모든 권한이 거부된 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('모든 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.'),
          action: SnackBarAction(
            label: '설정으로 이동',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        width: 360,
        height: 770,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 113,
            height: 104,
            child: Image.asset(
              'assets/Mogulogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

