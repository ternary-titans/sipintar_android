import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_mahasiswa/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String token = '';
  bool loginFailed = false;

  void _handleLoginButtonPressed() {
    String nim = nimController.text;
    String password = passwordController.text;

    if (nim.isNotEmpty && password.isNotEmpty) {
      login(nim, password);
    } else {
      print("Username and password are required.");
    }
  }

  Future<void> login(String nim, String password) async {
    var url = Uri.parse('http://192.168.0.104:3000/api/users/login');
    var headers = {"Content-Type": "application/json"};
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"username": nim, "password": password}),
    );

    if (response.statusCode == 200) {
      // Login berhasil
      var responseData = jsonDecode(response.body);
      print(responseData);
      var data = responseData['data'];
      token = data['token'];
      print("TOKEN $token");
      print('Login berhasil');

      // Simpan token menggunakan shared_preferences
      await saveToken(token);

      // Setelah login berhasil, pindah ke halaman beranda menggunakan Navigator
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Login gagal
      print(response.body);
      print('Login gagal');
      setState(() {
        loginFailed = true; // Step 2: Set login status to true
      });
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_token', token);
    print('Token berhasil disimpan: $token');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    print('Token yang diambil: $token');
    return token;
  }

  void getTokenAndUseIt() async {
    String? token = await getToken();
    if (token != null) {
      // Lakukan sesuatu dengan token, misalnya kirim ke server atau gunakan dalam permintaan API.
      print('Token yang didapatkan: $token');
    } else {
      print('Token tidak ditemukan.');
    }
  }

  @override
  void initState() {
    // Do something
    getTokenAndUseIt();
    super.initState();
  }

  @override
  void dispose() {
    nimController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/images/gedung_polines 1.png'),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 15,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Politeknik Negeri Semarang',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 3 - 100,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                color: Color(0xFF01509D),
              ),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Row(
                    children: [
                      SizedBox(width: 19),
                      Text(
                        'NIM',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 60),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 18),
                          child: Container(
                            width: 146,
                            height: 50,
                            child: TextField(
                              controller: nimController,
                              style: TextStyle(color: Color(0xff00296B)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffd9d9d9),
                                hintText: 'Input NIM',
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff8080)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(width: 19),
                      Text(
                        'PASSWORD',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 18),
                          child: Container(
                            width: 146,
                            height: 50,
                            child: TextField(
                              controller: passwordController,
                              style: TextStyle(color: Color(0xff00296B)),
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffd9d9d9),
                                hintText: 'Input Password',
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 136,
                    child: ElevatedButton(
                      onPressed: _handleLoginButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xfffed500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37),
                        ),
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00296B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (loginFailed)
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3 + 250),
              child: Text(
                'Password dan NIM salah. Coba lagi.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 8 + 530),
            child: Text(
              'P I N T A R',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 8 + 590),
            child: Container(
              width: 102,
              height: 102,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 8 + 601.5),
            child: Container(
              width: 87,
              height: 87,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logopolines.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height / 8 + 500),
            child: Text(
              'Polines`s Information and Attender',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
