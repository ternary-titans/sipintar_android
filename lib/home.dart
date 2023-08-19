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
    var url = Uri.parse('http://192.168.1.26:3000/api/users/current');
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

    var url = Uri.parse('http://192.168.1.26:3000/api/users/current');
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


class ScanQRPage extends StatefulWidget {
  const ScanQRPage({Key? key}) : super(key: key);

  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isScanning ? _buildScannerView() : _buildScanButton(),
    );
  }

  Widget _buildScanButton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Klik untuk melakukkan presensi',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isScanning = true;
              });
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFF00296B)),
              foregroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFFDC500)),
            ),
            child: const Text(
              'Scan QR Code',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isScanning = false;
        });
        return true;
      },
      child: SimpleBarcodeScannerPage(
        onResult: (barcode) {
          setState(() {
            result = barcode;
            isScanning = false;
          });
          _showSuccessDialog();
        },
      ),
    );
  }

  void _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Presensi Berhasil',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Berhasil melakukan presensi perkuliahan.\n'
            'Matakuliah: Pemrograman Game\n'
            'Tanggal: 07-08-2023\n'
            'Jam: 08.00\n'
            'Dosen: Liliek Triyono\n'
            'Topik Perkuliahan: Presentasi Tugas Besar',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
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
  final Function(Barcode) onResult;

  const SimpleBarcodeScannerPage({Key? key, required this.onResult})
      : super(key: key);

  @override
  _SimpleBarcodeScannerPageState createState() =>
      _SimpleBarcodeScannerPageState();
}

class _SimpleBarcodeScannerPageState extends State<SimpleBarcodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        final result = Barcode(code: scanData.code!);

        // Kirim data QR code ke endpoint
        sendDataToEndpoint(result);
        // Tampilkan dialog sukses
        _showSuccessDialog(result);

        // Berhenti memindai setelah mendapatkan hasil
        controller.pauseCamera();
        //widget.onResult(result);
      }
    });
  }

  String userToken = '';
  
  int mahasiswaId = -1;

  void sendDataToEndpoint(Barcode qrCodeData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    setState(() {
      userToken = token ?? '';
    });
    final String apiUrl = 'http://192.168.1.26:3000/api/presensi';

    Map<String, dynamic> requestBody = {
      'mahasiswaId': 1, // Replace with the actual mahasiswa_id
    'waktu_presensi': DateTime.now().toUtc().toIso8601String(), 
      'qrData': qrCodeData.code,
    
      // Add other data you want to send to the endpoint
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', 
                      "Authorization": userToken},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Jika request berhasil, tidak perlu tindakan khusus di sini
    } else {
      // Jika request gagal, tampilkan pesan error
      print('Error sending data to endpoint: ${response.statusCode}');
    }
  }

  void _showSuccessDialog(Barcode qrCodeData) async {
    String jwtToken = qrCodeData.code;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Presensi Berhasil',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Berhasil melakukan presensi perkuliahan.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'QR Code: ${qrCodeData.code}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            // Display decoded JWT token data
            Text(
              'Nama Mahasiswa: ${decodedToken['nama']}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            // Add more information from the decoded token
            // ...
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tutup'),
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pop(context); // Kembali ke halaman ScanQRPage
            },
          ),
        ],
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
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

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<List<String>> transposedData = [
    ['Jurusan', ''],
    ['Program Studi', ''],
    ['Kelas', ''],
  ];

  String userToken = '';
  int mhs_id = 0;

  Future<void> getCurrentUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    setState(() {
      userToken = token ?? '';
    });

    var url = Uri.parse('http://192.168.1.26:3000/api/users/current');
    var headers = {"Authorization": userToken};
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var userData = responseData['data'];

      setState(() {
        transposedData[0][1] = userData['jurusan'];
        transposedData[1][1] = userData['prodi'];
        transposedData[2][1] = userData['kelas'];
      });
    } else {
      print(response.body);
      print('Failed to fetch data');
    }
  }

  List<List<String>> secondTableData = [
    ['Hari', 'Waktu', 'Kode Matkul', 'Matkul', 'Dosen', 'Ruangan', 'Aksi'],
  ];
  List<String> secondTableHeader = [
    'Hari',
    'Waktu',
    'Kode Matkul',
    'Matkul',
    'Dosen',
    'Ruangan',
    'Aksi'
  ];

  Future<void> getJadwalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefsId = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    int? mhsId = prefsId.getInt('mhs_id');
    setState(() {
      userToken = token ?? '';
      mhs_id = mhsId ?? 0;
    });

    // int mahasiswaId =
    //     Provider.of<MahasiswaIdProvider>(context, listen: false).mahasiswaId;

    print("CekMHSID ${mhsId}");

    print("CekDataMahasiwaID : ${mhsId}");
    var url =
        Uri.parse('http://192.168.1.26:3000/api/mahasiswa/$mhsId/jadwal');
    var headers = {"Authorization": userToken};
    var response = await http.get(url, headers: headers);
    debugPrint(mhsId.toString());

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var jadwalData = responseData['data'];
      List<List<String>> newJadwalData = [];

      for (var jadwal in jadwalData) {
        List<String> rowData = [
          jadwal['hari'],
          '${jadwal['jam_mulai']} - ${jadwal['jam_akhir']}',
          jadwal['kode_mk'],
          jadwal['nama_mk'],
          jadwal['dosen'],
          jadwal['ruangan'],
          '',
        ];
        newJadwalData.add(rowData);
      }

      setState(() {
        secondTableData = newJadwalData;
      });
    } else {
      print('Gagal mengambil data jadwal');
    }
  }

  void navigateToAktivasiPage(List<String> rowData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AktivasiPage(jadwalData: rowData),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
    getJadwalData();
  }

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
                      secondTableHeader.map<DataColumn>((String columnValue) {
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
                      .sublist(0)
                      .map<DataRow>((List<String> rowData) {
                    return DataRow(
                      cells: rowData.asMap().entries.map<DataCell>((entry) {
                        int index = entry.key;
                        String cellValue = entry.value;
                        print("CekValueJadwalKuliah ${cellValue}");
                        if (index == rowData.length - 1) {
                          return DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    navigateToAktivasiPage(rowData);
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
                              ],
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
  final List<String> jadwalData;

  AktivasiPage({required this.jadwalData});

  @override
  State<AktivasiPage> createState() => _AktivasiPageState();
}

class _AktivasiPageState extends State<AktivasiPage> {
  int jadwalId = 1;
  TextEditingController topikController = TextEditingController();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  DateTime? selectedDate;
  final timeFormat = DateFormat.Hm();
  final timeFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,2}:[0-9]{0,2}$'));

  List<List<String>> transposedData = [
    ['Mata Kuliah', ''],
    ['Kode Matkul', ''],
    ['Jadwal', ''],
    ['Dosen', ''],
    ['Ruangan', ''],
    ['Realisasi Tanggal', 'Tanggal Kuliah Real'],
    ['Realisasi Jam', 'Jam Kuliah Real'],
    ['Topik Perkuliahan', 'Topik Kuliah'],
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
      });
    }
  }

  String mataKuliah = '';
  String kodeMatkul = '';
  String jadwal = '';
  String dosen = '';
  String ruangan = '';
  String userToken = '';

  Future<void> fetchJadwalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    setState(() {
      userToken = token ?? '';
    });

    //   var url =
    //       Uri.parse('http://192.168.18.79:3000/api/mahasiswa/$jadwalId/jadwal');
    //   var headers = {"Authorization": userToken};
    //   var response = await http.get(url, headers: headers);
    //   print('Response: ${response.statusCode} - ${response.body}');

    //   if (response.statusCode == 200) {
    //     var responseData = jsonDecode(response.body);
    //     var jadwalDataList = responseData['data'] as List<dynamic>;

    //     if (jadwalDataList.isNotEmpty) {
    //       var jadwalData =
    //           jadwalDataList[0]; // Ambil objek jadwal pertama dari list
    //       setState(() {
    // mataKuliah = jadwalData['nama_mk'];
    // kodeMatkul = jadwalData['kode_mk'];
    // jadwal = '${jadwalData['jam_mulai']} - ${jadwalData['jam_akhir']}';
    // dosen = jadwalData['dosen'];
    // ruangan = jadwalData['ruangan'];
    //       });
    //     }
    //   } else {
    //     print(
    //         'Gagal mengambil data jadwal: ${response.statusCode} - ${response.body}');
    //   }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      transposedData[0][1] = widget.jadwalData[3];
      transposedData[1][1] = widget.jadwalData[2];
      transposedData[2][1] = widget.jadwalData[1];
      transposedData[3][1] = widget.jadwalData[4];
      transposedData[4][1] = widget.jadwalData[5];

      // kodeMatkul = jadwalData['kode_mk'];
      // jadwal = '${jadwalData['jam_mulai']} - ${jadwalData['jam_akhir']}';
      // dosen = jadwalData['dosen'];
      // ruangan = jadwalData['ruangan'];
    });
    fetchJadwalData();

// // Bagian yang memeriksa dan mengatur jadwalId
//     String jadwalIdString = widget.jadwalData[0];

// // Melanjutkan ke bagian pemanggilan API
//     fetchJadwalData(jadwalId);
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
                      print("CekCellValue : ${cellValue}");
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
                              // Logic to update data when text field changes
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
                                  getFormattedTime(selectedStartTime),
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
                                  getFormattedTime(selectedEndTime),
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
                    "*Setelah klik button AKTIVASI PERKULIAHAN, diharap mahasiswa segera melakukan scan QR Code.",
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
                onPressed: () async {
                  final Map<String, dynamic> requestData = {
                    "hari": "Senin",
                    "jam_mulai": "16:00",
                    "jam_akhir": "19:00",
                    "waktu_realisasi": "2023-01-15T08:00:00.000Z",
                    "ruangan": "SB-1/1",
                    "total_jam": 4,
                    "topik_perkuliahan": "CSS",
                    "kelas_mk_dosen_id": 1
                  };

                  print("CekUserToken $userToken");

                  final response = await http.post(
                    Uri.parse(
                        'http://192.168.1.26:3000/api/aktivasiPerkuliahan'),
                    headers: {
                      "Content-Type": "application/json",
                      "Authorization": userToken
                    },
                    body: jsonEncode(requestData),
                  );

                  if (response.statusCode == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Berhasil melakukan aktivasi perkuliahan.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff00296B),
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Gagal melakukan aktivasi perkuliahan.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff00296B),
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
                  }
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
            )
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: SchedulePage()));
