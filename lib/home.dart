import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:presensi_mahasiswa/home_content.dart';
import 'package:presensi_mahasiswa/message_content.dart';
import 'package:presensi_mahasiswa/recap_content.dart';
import 'package:presensi_mahasiswa/scan_qr_content.dart';
import 'package:presensi_mahasiswa/schedule_content.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          "PINTAR",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, size: 38),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Apakah anda yakin ingin keluar?",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff00296B),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff00296B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFED501),
                          ),
                        ),
                        onPressed: () {
                          // Perform logout action here
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff00296B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFED501),
                          ),
                        ),
                        onPressed: () {
                          // Perform logout action here
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeContent(),
          RecapPage(),
          ScanQRPage(),
          MessagePage(),
          SchedulePage(),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        height: 80,
        backgroundColor: Color(0xFFFDC500),
        color: Color(0xFF00296B),
        activeColor: Color(0xff5F5F5F),
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.checklist, title: 'Recap'),
          TabItem(icon: Icons.qr_code_scanner, title: 'ScanQR'),
          TabItem(icon: Icons.message, title: 'Message'),
          TabItem(icon: Icons.schedule, title: 'Schedule'),
        ],
        initialActiveIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


// void main() => runApp(MaterialApp(home: SchedulePage()));
