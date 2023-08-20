import 'package:flutter/material.dart';
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

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String userToken = '';
  String namaMahasiswa = '';
  String nim = '';
  String kelas = '';
  String jurusan = '';
  int mahasiswaId = -1;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefsId = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    setState(() {
      userToken = token ?? '';
    });
    var url = Uri.parse('http://192.168.0.104:3000/api/users/current');
    var headers = {"Authorization": userToken};
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print(responseData);
      var data = responseData['data'];
      var id = data['id'];

      Provider.of<MahasiswaIdProvider>(context, listen: false)
          .setMahasiswaId(id);

      int mhsId =
          Provider.of<MahasiswaIdProvider>(context, listen: false).mahasiswaId;

      prefsId.setInt('mhs_id', mhsId);

      print("CekMHSID ${mhsId}");

      setState(() {
        namaMahasiswa = data['nama_mahasiswa'];
        nim = data['nim'];
        kelas = data['kelas'];
        jurusan = data['jurusan'];
      });
    } else {
      print(response.body);
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFF00296B),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height / 3,
          child: Opacity(
            opacity: 0.4,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                      image: AssetImage('assets/images/gedung_polines 1.png'),
                      fit: BoxFit.cover)),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 3 - 80,
          left: MediaQuery.of(context).size.width / 2 - 160,
          width: 320,
          height: 160,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff01509d),
              borderRadius: BorderRadius.circular(38),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/logopolines.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Polines`s Information and Attender',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 8 + 60,
          left: 0,
          right: 0,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome,',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffdc500),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  namaMahasiswa,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xfffdc500),
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '$kelas / $nim / $jurusan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Color(0xfffdc500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
