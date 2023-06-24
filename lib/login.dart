import 'package:flutter/material.dart';
import 'package:presensi_mahasiswa/home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
            top: MediaQuery.of(context).size.height / 3 + 100,
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
                  SizedBox(height: 85),
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
                              style: TextStyle(color: Colors.white),
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
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffd9d9d9),
                                hintText: 'Input Password',
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
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
                  SizedBox(
                    width: 136,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
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
          Positioned(
            top: MediaQuery.of(context).size.height / 3 + 51,
            left: MediaQuery.of(context).size.width / 2 - 51,
            child: Container(
              width: 102,
              height: 102,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3 + 55,
            left: MediaQuery.of(context).size.width / 2 - 43.5,
            child: Container(
              width: 87,
              height: 87,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logopolines.png'),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 8 + 530,
            left: 0,
            right: 0,
            child: Center(
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
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 8 + 590,
            left: MediaQuery.of(context).size.width / 2 - 51,
            child: Container(
              width: 102,
              height: 102,
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 8 + 601.5,
            left: MediaQuery.of(context).size.width / 2 - 43.5,
            child: Container(
              width: 87,
              height: 87,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logopolines.png'),
                      fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 8 + 500,
            left: 0,
            right: 0,
            child: Center(
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
          ),
        ],
      )),
    );
  }
}
