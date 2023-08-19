import 'package:flutter/material.dart';
import 'package:presensi_mahasiswa/splashscreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MahasiswaIdProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MahasiswaIdProvider extends ChangeNotifier {
  int _mahasiswaId = 0;

  int get mahasiswaId => _mahasiswaId;

  void setMahasiswaId(int id) {
    _mahasiswaId = id;
    print("CekDataKU : ${_mahasiswaId}");
    notifyListeners();
  }
}
