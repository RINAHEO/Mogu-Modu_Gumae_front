import 'package:flutter/material.dart';

class PostReportPage extends StatefulWidget {
  const PostReportPage({super.key});

  @override
  _PostReportPageState createState() => _PostReportPageState();
}

class _PostReportPageState extends State<PostReportPage> {
  String? _selectedReportType; // 선택된 신고 유형을 저장하는 변수
  final TextEditingController _reportController = TextEditingController();

  @override
  void dispose() {
    _reportController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
              colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView( // 스크롤 가능하도록 변경
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '신고 종류를 선택해주세요.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildCheckboxOption('그냥 신고'),
              _buildCheckboxOption('허위 정보'),
              _buildCheckboxOption('불쾌한 내용'),
              _buildCheckboxOption('스팸'),
              _buildCheckboxOption('기타'),
              SizedBox(height: 32),
              Text(
                '신고 내용을 입력해주세요.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _reportController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: '신고 내용을 입력해주세요.',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.only(top: 9, left: 11, right: 12, bottom: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
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
                  onTap: () {
                    // 신고하기 버튼 눌렀을 때 동작을 정의하세요.
                    print('신고 내용: ${_reportController.text}');
                    print('신고 종류: $_selectedReportType');
                  },
                  borderRadius: BorderRadius.circular(10),
                  splashColor: Colors.white.withOpacity(0.3),
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        '신고하기',
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
    );
  }

  Widget _buildCheckboxOption(String title) {
    return CheckboxListTile(
      title: Text(title),
      value: _selectedReportType == title,
      onChanged: (bool? value) {
        setState(() {
          _selectedReportType = value! ? title : null;
        });
      },
      activeColor: Color(0xFFB34FD1),
      controlAffinity: ListTileControlAffinity.leading, // 체크박스를 왼쪽에 배치
    );
  }
}