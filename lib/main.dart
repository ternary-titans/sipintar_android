import 'package:flutter/material.dart';
import 'package:presensi_mahasiswa/login.dart';
import 'package:presensi_mahasiswa/home.dart';
import 'package:presensi_mahasiswa/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
