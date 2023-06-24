import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 8 + 170,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Welcome,',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xfffdc500),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 8 + 140,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Nur Imam Nazihah',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xfffdc500),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 8 + 120,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'ABT-3A / 4.52.20.0.21 / Semester 6',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Color(0xfffdc500),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 3 - 60,
          left: MediaQuery.of(context).size.width / 2 - 43,
          child: Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 8 + 240,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Polines`s Information and Attender',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 3 + 105,
          left: MediaQuery.of(context).size.width / 2 - 36.5,
          child: Container(
            width: 73,
            height: 73,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logopolines.png'),
                    fit: BoxFit.cover)),
          ),
        ),
      ],
    );
  }
}

class RecapPage extends StatefulWidget {
  const RecapPage({Key? key}) : super(key: key);

  @override
  State<RecapPage> createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
  List<List<String>> sourceData = [
    [
      'Nama Mahasiswa',
      'NIM',
      'Kelas',
      'Jurusan',
      'Program Studi',
      'Semester',
      'Dosen Wali',
    ],
    [
      'Nur Imam Nazihah',
      '4.52.20.0.21',
      'ABT-3A',
      'Administrasi Bisnis',
      'D4-Administrasi Bisnis Terapan',
      'VI / Genap',
      'Iwan Hermawan',
    ],
  ];

  List<List<String>> transposedData = [
    ['Nama Mahasiswa', 'Nur Imam Nazihah'],
    ['NIM', '4.52.20.0.21'],
    ['Kelas', 'ABT-3A'],
    ['Jurusan', 'Administrasi Bisnis'],
    ['Prodi', 'D4-Administrasi Bisnis Terapan'],
    ['Semester', 'VI / Genap'],
    ['Dosen Wali', 'Iwan Hermawan'],
  ];

  List<List<String>> secondTableData = [
    [
      'No',
      'Mata Kuliah',
      'Jumlah Pertemuan',
      'Hadir',
      'Izin',
      'Alpa',
      'Sakit',
      'Presentase',
      'Aksi'
    ],
    [
      '1',
      'Basis Data',
      '16',
      '10',
      '4',
      '1',
      '1',
      '62.5%',
      'Lihat Detail',
    ],
    [
      '2',
      'Basis Data',
      '16',
      '10',
      '4',
      '1',
      '1',
      '62.5%',
      'Lihat Detail',
    ],
    [
      '3',
      'Basis Data',
      '16',
      '10',
      '4',
      '1',
      '1',
      '62.5%',
      'Lihat Detail',
    ],
    [
      '4',
      'Basis Data',
      '16',
      '10',
      '4',
      '1',
      '1',
      '62.5%',
      'Lihat Detail',
    ],
    [
      '5',
      'Basis Data',
      '16',
      '10',
      '4',
      '1',
      '1',
      '62.5%',
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
      n += int.parse(secondTableData[i][6]);
      y += int.parse(secondTableData[i][4]);
      x += int.parse(secondTableData[i][5]);
    }

    String sakitText = 'Sakit   : $n Hari';
    String izinText = 'Izin       : $y Hari';
    String alpaText = 'Alpa    : $x Hari';

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
      'Jumlah SKS',
      'Dosen',
    ],
    [
      '2022/2023',
      '123-234-345',
      'Basis Data',
      '16 Pertemuan',
      '24 SKS',
      'Iwan Hermawan'
    ]
  ];

  List<List<String>> transposedData = [
    ['Tahun Ajaran', '2022/2023'],
    ['Kode Matkul', '123-234-345'],
    ['Mata Kuliah', 'Basis Data'],
    ['Jumlah Pertemuan', '16 Pertemuan'],
    ['Jumlah SKS', '24 SKS'],
    ['Dosen', 'Iwan Hermawan']
  ];

  List<List<String>> secondTableData = [
    [
      'No',
      'Tanggal Realisasi',
      'Jam Realisasi',
      'Jumlah SKS',
      'Topik Perkuliahan',
      'Keterangan'
    ],
    ['1', '01/02/23', '07.00-08.30', '2 SKS', 'Pengenalan Database', 'Hadir'],
    ['2', '03/02/23', '07.00-08.30', '2 SKS', 'Pengenalan Database', 'Sakit'],
    ['3', '05/02/23', '07.00-08.30', '2 SKS', 'Pengenalan Database', 'Izin'],
    ['4', '09/02/23', '07.00-08.30', '2 SKS', 'Pengenalan Database', 'Alpa'],
    [
      '5',
      '10/02/23',
      '07.00-08.30',
      '2 SKS',
      'Pengenalan Database',
      'Terlambat 5-90 menit'
    ],
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
                    headingRowHeight: 30,
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

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({Key? key}) : super(key: key);

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isQRDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              var res = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => SimpleBarcodeScannerPage(),
                ),
              );
              setState(() {
                if (res != null) {
                  result = Barcode(code: res);
                  _showSuccessDialog();
                }
              });
            },
            child: const Text('PRESENSI PERKULIAHAN'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Presensi Berhasil'),
          content: Text('Berhasil melakukan presensi perkuliahan.\n'
              'QR Code: ${result?.code}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class SimpleBarcodeScannerPage extends StatefulWidget {
  const SimpleBarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _SimpleBarcodeScannerPageState createState() =>
      _SimpleBarcodeScannerPageState();
}

class _SimpleBarcodeScannerPageState extends State<SimpleBarcodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  Barcode? result;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        if (scanData.code != null) {
          result = Barcode(code: scanData.code!);
          Navigator.of(context).pop(result);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Barcode {
  final String code;

  Barcode({required this.code});
}

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
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Color(0xFF01509D),
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

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<List<String>> sourceData = [
    [
      'Jurusan',
      'Program Studi',
      'Semester',
      'Tahun Akademik',
      'Kelas',
      'Dosen Wali'
    ],
    [
      'Administrasi Bisnis',
      'D4-Administrasi Bisnis Terapan',
      'VI / Genap',
      '2022/2023',
      'ABT-3A',
      'Iwan Hermawan'
    ],
  ];

  List<List<String>> transposedData = [
    ['Jurusan', 'Administrasi Bisnis'],
    ['Program Studi', 'D4-Administrasi Bisnis Terapan'],
    ['Semester', 'VI / Genap'],
    ['Tahun Akademik', '2022/2023'],
    ['Kelas', 'ABT-3A'],
    ['Dosen Wali', 'Iwan Hermawan'],
  ];

  List<List<String>> secondTableData = [
    ['Tanggal', 'Jam', 'Kode Matkul', 'Matkul', 'Dosen', 'Ruangan', 'Aksi'],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
    [
      '01-02-22',
      '08:00-10:00',
      '123-345-567',
      'Pemrograman Basis Data',
      'Iwan Hermawan',
      'MSTIII/02',
      'Aktivasi'
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              'Jadwal Perkuliahan Mingguan',
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
                  headingRowHeight: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[200],
                  ),
                  columns:
                      secondTableData[0].map<DataColumn>((String columnValue) {
                    return DataColumn(
                      label: Container(
                        width: 80,
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
                        if (cellValue == 'Aktivasi') {
                          return DataCell(
                            Container(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AktivasiPage()),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xFF00296B)),
                                ),
                                child: Text(
                                  'Aktivasi',
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
                              width: 80,
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
        ],
      ),
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

class AktivasiPage extends StatefulWidget {
  @override
  State<AktivasiPage> createState() => _AktivasiPageState();
}

class _AktivasiPageState extends State<AktivasiPage> {
  TextEditingController topikController = TextEditingController();
  TimeOfDay selectedStartTime = TimeOfDay.now(); // Store selected start time
  TimeOfDay selectedEndTime = TimeOfDay.now(); // Store selected end time
  DateTime? selectedDate; // Store selected date
  final timeFormat = DateFormat.Hm(); // Format waktu hh:mm
  final timeFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,2}:[0-9]{0,2}$'));
  String selectedSKS = 'Pilih Jumlah SKS';

  List<List<String>> sourceData = [
    [
      'Tahun Ajaran',
      'Mata Kuliah',
      'Kode Matkul',
      'Jadwal',
      'Dosen',
      'Ruangan',
      'Realisasi Tanggal',
      'Realisasi Jam',
      'Topik Perkuliahan',
      'Jumlah SKS',
    ],
    [
      '2022/2023',
      'Pemrograman Basis Data',
      '123-345-567',
      '08.00-10.00',
      'Iwan Hermawan',
      'MSTIII/02',
      'Tanggal Kuliah Real',
      'Jam Kuliah Real',
      'Topik Kuliah',
      'Pilih Jumlah SKS'
    ]
  ];

  List<List<String>> transposedData = [
    ['Tahun Ajaran', '2022/2023'],
    ['Mata Kuliah', 'Pemrograman Basis Data'],
    ['Kode Matkul', '123-345-567'],
    ['Jadwal', '08.00-10.00'],
    ['Dosen', 'Iwan Hermawan'],
    ['Ruangan', 'MSTIII/02'],
    ['Realisasi Tanggal', 'Tanggal Kuliah Real'],
    ['Realisasi Jam', 'Jam Kuliah Real'],
    ['Topik Perkuliahan', 'Topik Kuliah'],
    ['Jumlah SKS', 'Pilih Jumlah SKS']
  ];

  List<List<String>> alreadyPresenceTable = [
    ['No', 'Nama', 'NIM', 'Waktu Presensi'],
    ['1', 'Talitha Padmarini Shafira', '3.34.20.0.23', '08:00'],
    ['2', 'Rifka Anggun Puspitaningrum', '3.34.20.0.21', '08:01'],
    ['3', 'Nur Imam Nazihah', '4.52.20.0.21', '08.02'],
    ['4', 'Choirul Anam', '4.52.20.0.22', '08.04'],
  ];

  @override
  void dispose() {
    topikController.dispose();
    super.dispose();
  }

  String getFormattedTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.Hm().format(dateTime);
  }

  String getSelectedTimeRange() {
    final startTime = getFormattedTime(selectedStartTime);
    final endTime = getFormattedTime(selectedEndTime);
    return '$startTime - $endTime';
  }

  Future<void> selectStartTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );

    if (pickedTime != null && pickedTime != selectedStartTime) {
      setState(() {
        selectedStartTime = pickedTime;
        sourceData[1][7] = getFormattedTime(selectedStartTime);
        selectedEndTime = selectedStartTime;
      });
    }
  }

  Future<void> selectEndTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );

    if (pickedTime != null && pickedTime != selectedEndTime) {
      setState(() {
        selectedEndTime = pickedTime;
        sourceData[1][7] = getSelectedTimeRange();
      });
    }
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        sourceData[1][6] = DateFormat('dd-MM-yy').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFDC500),
        foregroundColor: Color(0xff00296B),
        title: Text(
          "Aktivasi Perkuliahan",
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
                'Aktivasi Perkuliahan',
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
                dataRowHeight: 40,
                headingRowHeight: 40,
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
                      if (cellValue == 'Topik Kuliah') {
                        return DataCell(
                          TextField(
                            controller: topikController,
                            decoration: InputDecoration(
                              hintText: 'Tuliskan Topik Perkuliahan Anda',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (value) {
                              setState(() {
                                sourceData[1][8] = value;
                              });
                            },
                          ),
                        );
                      } else if (cellValue == 'Jam Kuliah Real') {
                        return DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: selectStartTime,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffFED500),
                                ),
                                child: Text(
                                  selectedStartTime != null
                                      ? getFormattedTime(selectedStartTime)
                                      : 'Mulai Kuliah',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff00296B),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: selectEndTime,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffFED500),
                                ),
                                child: Text(
                                  selectedEndTime != null
                                      ? getFormattedTime(selectedEndTime)
                                      : 'Akhir Kuliah',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff00296B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (cellValue == 'Tanggal Kuliah Real') {
                        return DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: selectDate,
                                icon: Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Color(0xff00296B),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                selectedDate != null
                                    ? DateFormat('dd-MM-yy')
                                        .format(selectedDate!)
                                    : '',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (cellValue == 'Pilih Jumlah SKS') {
                        return DataCell(
                          DropdownButton<String>(
                            value: selectedSKS,
                            items: [
                              'Pilih Jumlah SKS',
                              '1 SKS',
                              '2 SKS',
                              '3 SKS',
                              '4 SKS',
                              '5 SKS',
                              '6 SKS',
                              '7 SKS',
                              '8 SKS',
                              '9 SKS',
                              '10 SKS',
                              '11 SKS',
                              '12 SKS',
                              '13 SKS',
                              '14 SKS',
                              '15 SKS',
                              '16 SKS',
                              '17 SKS',
                              '18 SKS',
                              '19 SKS',
                              '20 SKS',
                              '21 SKS',
                              '22 SKS',
                              '23 SKS',
                              '24 SKS'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedSKS = newValue!;
                                sourceData[1][9] = newValue;
                              });
                            },
                          ),
                        );
                      } else {
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
                      }
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "*Pilih tanggal dan jam perkuliahan sesuai realisasi perkuliahan.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffF24E1E),
                    ),
                  ),
                  Text(
                    "*Aktivasi perkuliahan hanya bisa dilakukan satu kali oleh salah satu perwakilan kelas saja.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffF24E1E),
                    ),
                  ),
                  Text(
                    "*Setelah klik button AKTIVASI PERKULIAHAN, diharap mahasiswa segera melakukan scan QR Code, karena QR Code hanya berlaku selama 15 menit saja.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffF24E1E),
                    ),
                  ),
                  Text(
                    "*Apabila jika ada mahasiswa yang lewat 15 menit belum melakukan scan QR Code, harap mengkonfirmasi kepada dosen matakuliah.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffF24E1E),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'QR Code ini berlaku selama 15 menit',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff00296B),
                          ),
                        ),
                        content: SizedBox(
                          width: 300,
                          height: 280,
                          child: QrImage(
                            data:
                                "kodematkul_realisasi tanggal_realisasi jam_kelas",
                            version: QrVersions.auto,
                            size: 200,
                            foregroundColor: Color(0xff00296B),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffFED501),
                              foregroundColor: Color(0xff00296B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFED501),
                  foregroundColor: Color(0xff00296B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(
                    'AKTIVASI PERKULIAHAN',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: DataTable(
                    dataRowHeight: 50,
                    headingRowHeight: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[200],
                    ),
                    columns: alreadyPresenceTable[0]
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
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                    rows: alreadyPresenceTable
                        .sublist(1)
                        .map<DataRow>((List<String> rowData) {
                      return DataRow(
                        cells: rowData.map<DataCell>((String cellValue) {
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
