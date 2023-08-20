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

class DetailRecapPage extends StatefulWidget {
  @override
  _DetailRecapPageState createState() => _DetailRecapPageState();
}

class _DetailRecapPageState extends State<DetailRecapPage> {
  List<List<String>> sourceData = [
    [
      'Tahun Ajaran',
      'Kode Matkul',
      'Mata Kuliah',
      'Jumlah Pertemuan',
      'Dosen',
    ],
    ['2022/2023', '123-234-345', 'Jaringan Komputer', '30 jam', 'Mardiyono']
  ];

  List<List<String>> transposedData = [
    ['Tahun Ajaran', '2022/2023'],
    ['Kode Matkul', '123-234-345'],
    ['Mata Kuliah', 'Jaringan Komputer'],
    ['Jumlah Pertemuan', '30 jam'],
    ['Dosen', 'Mardiyono']
  ];

  List<List<String>> secondTableData = [
    [
      'No',
      'Tanggal Realisasi \n Jam Realisasi',
      'Topik Perkuliahan',
      'Keterangan'
    ],
    ['1', '01/02/23 \n 07.00-08.30', 'Pengenalan Jaringan', 'Hadir'],
    ['2', '03/02/23 \n 07.00-08.30', 'Presentasi', 'Hadir'],
    ['3', '05/02/23 \n 07.00-08.30', 'Konfigurasi Jaringan', 'Hadir'],
    ['4', '09/02/23 \n 07.00-08.30', 'IP Address', 'Hadir'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          "Detail Kehadiran",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff00296B),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Detail Kehadiran',
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
                columns:
                    transposedData[0].map<DataColumn>((String columnValue) {
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
                    return DataCell(
                      Text(
                        cellValue,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
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
                    headingRowHeight: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[200],
                    ),
                    columns: secondTableData[0]
                        .map<DataColumn>((String columnValue) {
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
                            textAlign: TextAlign.left,
                          ),
                        ),
                      );
                    }).toList(),
                    rows: secondTableData
                        .sublist(1)
                        .map<DataRow>((List<String> rowData) {
                      return DataRow(
                        cells: rowData.map<DataCell>((String cellValue) {
                          return DataCell(
                            Container(
                              child: Text(
                                cellValue,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
