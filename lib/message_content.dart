import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:presensi_mahasiswa/main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';



class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              'PERINGATAN SP 1 !!!',
              'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 11 JAM.\nLihat selengkapnya...',
              () {
                _navigateToMessagePeringatan11();
                _showNotification(
                  'PERINGATAN SP 1 !!!',
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 11 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              'PERINGATAN SP 1 !!!',
              'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 14 JAM.\nLihat selengkapnya...',
              () {
                _navigateToMessagePeringatan14();
                _showNotification(
                  'PERINGATAN SP 1 !!!',
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 14 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              'SURAT PERINGATAN 1 !!!',
              'Saat ini Anda mendapatkan SURAT PERINGATAN 1, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak 16 JAM.\nLihat selengkapnya...',
              () {
                _navigateToMessageSP1();
                _showNotification(
                  'SURAT PERINGATAN 1 !!!',
                  'Saat ini Anda mendapatkan SURAT PERINGATAN 1, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak 16 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              'PERINGATAN SP 2 !!!',
              'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 19 JAM.\nLihat selengkapnya..',
              () {
                _navigateToMessagePeringatan19();
                _showNotification(
                  'PERINGATAN SP 2 !!!',
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 19 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              'PERINGATAN SP 2 !!!',
              'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 22 JAM.\nLihat selengkapnya..',
              () {
                _navigateToMessagePeringatan22();
                _showNotification(
                  'PERINGATAN SP 2 !!!',
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 22 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              'SURAT PERINGATAN 2 !!!',
              'Saat ini Anda mendapatkan SURAT PERINGATAN 2, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak 24 JAM.\nLihat selengkapnya...',
              () {
                _navigateToMessageSP2();
                _showNotification(
                  'SURAT PERINGATAN 2 !!!',
                  'Saat ini Anda mendapatkan SURAT PERINGATAN 2, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak 24 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              'PERINGATAN SP 3 !!!',
              'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 27 JAM.\nLihat selengkapnya..',
              () {
                _navigateToMessagePeringatan27();
                _showNotification(
                  'PERINGATAN SP 3 !!!',
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 27 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              'PERINGATAN SP 3 !!!',
              'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 30 JAM.\nLihat selengkapnya..',
              () {
                _navigateToMessagePeringatan30();
                _showNotification(
                  'PERINGATAN SP 3 !!!',
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak mengikuti perkuliahan sebanyak 30 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              'SURAT PERINGATAN 3 !!!',
              'Saat ini Anda mendapatkan SURAT PERINGATAN 3, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak 32 JAM.\nLihat selengkapnya...',
              () {
                _navigateToMessageSP3();
                _showNotification(
                  'SURAT PERINGATAN 3 !!!',
                  'Saat ini Anda mendapatkan SURAT PERINGATAN 3, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak 32 JAM.\nLihat selengkapnya...',
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToMessagePeringatan11() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePeringatan11()),
    );
  }

  void _navigateToMessagePeringatan14() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePeringatan14()),
    );
  }

  void _navigateToMessageSP1() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageSP1()),
    );
  }

  void _navigateToMessagePeringatan19() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePeringatan19()),
    );
  }

  void _navigateToMessagePeringatan22() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePeringatan22()),
    );
  }

  void _navigateToMessageSP2() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageSP2()),
    );
  }

  void _navigateToMessagePeringatan27() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePeringatan27()),
    );
  }

  void _navigateToMessagePeringatan30() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessagePeringatan30()),
    );
  }

  void _navigateToMessageSP3() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MessageSP3()),
    );
  }

  Widget _buildCard(String title, String content, VoidCallback onPressed) {
    Color cardColor;
    if (title == 'SURAT PERINGATAN 1 !!!' ||
        title == 'SURAT PERINGATAN 2 !!!' ||
        title == 'SURAT PERINGATAN 3 !!!') {
      cardColor = Color(0xFF670000);
    } else {
      cardColor = Color(0xFF01509D);
    }
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0XFFFED500),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNotification(String title, String content) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(content),
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      content,
      platformChannelSpecifics,
      payload: 'your_payload',
    );
  }
}



class MessagePeringatan11 extends StatelessWidget {
  const MessagePeringatan11({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PERINGATAN SP 1',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '11 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 1 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '16 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessagePeringatan14 extends StatelessWidget {
  const MessagePeringatan14({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PERINGATAN SP 1',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '14 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 1 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '16 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageSP1 extends StatelessWidget {
  const MessageSP1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SURAT PERINGATAN 1',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini Anda mendapatkan SURAT PERINGATAN 1, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '16 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 1 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '16 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessagePeringatan19 extends StatelessWidget {
  const MessagePeringatan19({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PERINGATAN SP 2',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '19 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 2 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '24 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessagePeringatan22 extends StatelessWidget {
  const MessagePeringatan22({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PERINGATAN SP 2',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '22 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 2 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '24 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageSP2 extends StatelessWidget {
  const MessageSP2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SURAT PERINGATAN 2',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini Anda mendapatkan SURAT PERINGATAN 2, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '24 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 2 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '24 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessagePeringatan27 extends StatelessWidget {
  const MessagePeringatan27({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PERINGATAN SP 3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '27 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 3 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '32 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessagePeringatan30 extends StatelessWidget {
  const MessagePeringatan30({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PERINGATAN SP 3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini tercatat pada rekapitulasi presensi, bahwa Anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '30 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 3 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '32 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageSP3 extends StatelessWidget {
  const MessageSP3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          'Peringatan SP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SURAT PERINGATAN 3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Saat ini Anda mendapatkan SURAT PERINGATAN 3, dikarenakan tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '32 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Sesuai PERAK, Anda akan mendapatkan SURAT PERINGATAN 3 jika anda tidak hadir perkuliahan tanpa keterangan (ALPA) sebanyak :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '32 JAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Untuk melihat rekapitulasi presensi secara lengkap, kunjungi menu “RECAP”.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xff00296B),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'JIKA TERDAPAT KESALAHAN PADA REKAPITULASI PRESENSI, HARAP SEGERA HUBUNGI PBM SESUAI JURUSAN ANDA !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffF21E1E),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
