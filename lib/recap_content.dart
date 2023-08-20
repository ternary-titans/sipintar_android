import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:presensi_mahasiswa/detail_recap_content.dart';
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

class RecapPage extends StatefulWidget {
  const RecapPage({Key? key}) : super(key: key);

  @override
  State<RecapPage> createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
  List<List<String>> transposedData = [
    ['Nama Mahasiswa', ''],
    ['NIM', ''],
    ['Kelas', ''],
    ['Jurusan', ''],
    ['Program Studi', ''],
  ];

  String userToken = '';

  Future<void> getCurrentUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    setState(() {
      userToken = token ?? '';
    });

    var url = Uri.parse('http://192.168.0.104:3000/api/users/current');
    var headers = {"Authorization": userToken};
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var userData = responseData['data'];

      setState(() {
        transposedData[0][1] = userData['nama_mahasiswa'];
        transposedData[1][1] = userData['nim'];
        transposedData[2][1] = userData['kelas'];
        transposedData[3][1] = userData['jurusan'];
        transposedData[4][1] = userData['prodi'];
      });
    } else {
      print(response.body);
      print('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  List<List<String>> secondTableData = [
    [
      'No',
      'Mata Kuliah',
      'Jumlah Jam Pertemuan',
      'Hadir',
      'Izin',
      'Alpa',
      'Sakit',
      'Presentase',
      'Aksi'
    ],
    [
      '1',
      'Basis Data Jaringan',
      '32 jam',
      '30 jam',
      '0 jam',
      '2 jam',
      '0 jam',
      '93.75%',
      'Lihat Detail',
    ],
    [
      '2',
      'Sistem Informasi',
      '36 jam',
      '36 jam',
      '0 jam',
      '0 jam',
      '0 jam',
      '100%',
      'Lihat Detail',
    ],
    [
      '3',
      'Pemrograman Game',
      '28 jam',
      '28 jam',
      '0 jam',
      '0 jam',
      '0 jam',
      '100%',
      'Lihat Detail',
    ],
    [
      '4',
      'Jaringan Komputer',
      '30 jam',
      '30 jam',
      '0 jam',
      '0 jam',
      '0 jam',
      '100%',
      'Lihat Detail',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate the values of n, y, and x
    int n = 0;
    int y = 0;
    int x = 0;

    for (int i = 1; i < secondTableData.length; i++) {
      String sakitValue =
          secondTableData[i][6].replaceAll(RegExp(r'[^0-9]'), '');
      String izinValue =
          secondTableData[i][4].replaceAll(RegExp(r'[^0-9]'), '');
      String alpaValue =
          secondTableData[i][5].replaceAll(RegExp(r'[^0-9]'), '');

      n += int.parse(sakitValue);
      y += int.parse(izinValue);
      x += int.parse(alpaValue);
    }

    String sakitText = 'Sakit   : $n Jam';
    String izinText = 'Izin       : $y Jam';
    String alpaText = 'Alpa    : $x Jam';

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              'Rekapitulasi Presensi',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff00296B),
              ),
            ),
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 30,
              headingRowHeight: 30,
              columns: transposedData[0].map<DataColumn>((String columnValue) {
                return DataColumn(
                  label: Text(
                    columnValue,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
              rows: transposedData
                  .sublist(1)
                  .map<DataRow>((List<String> rowData) {
                return DataRow(
                    cells: rowData.map<DataCell>((String cellValue) {
                  return DataCell(Text(
                    cellValue,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ));
                }).toList());
              }).toList(),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: DataTable(
                  dataRowHeight: 50,
                  headingRowHeight: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[200],
                  ),
                  columns:
                      secondTableData[0].map<DataColumn>((String columnValue) {
                    return DataColumn(
                      label: Container(
                        child: Text(
                          columnValue,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  rows: secondTableData
                      .sublist(1)
                      .map<DataRow>((List<String> rowData) {
                    return DataRow(
                      cells: rowData.map<DataCell>((String cellValue) {
                        if (cellValue == 'Lihat Detail') {
                          return DataCell(
                            Container(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailRecapPage()),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF00296B)),
                                ),
                                child: Text(
                                  'Lihat Detail',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFDC500),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return DataCell(
                            Container(
                              child: Text(
                                cellValue,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              sakitText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff00296B),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              izinText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff00296B),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              alpaText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff00296B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
