import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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

class AktivasiPage extends StatefulWidget {
  final List<dynamic> jadwalData;

  AktivasiPage({required this.jadwalData});

  @override
  State<AktivasiPage> createState() => _AktivasiPageState();
}

class _AktivasiPageState extends State<AktivasiPage> {
  // int jadwalId = 1;
  TextEditingController topikController = TextEditingController();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  DateTime? selectedDate;
  final timeFormat = DateFormat.Hm();
  final timeFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,2}:[0-9]{0,2}$'));

  List<List<dynamic>> transposedData = [
    ['Mata Kuliah', ''],
    ['Kode Matkul', ''],
    ['Jadwal', ''],
    ['Dosen', ''],
    ['Ruangan', ''],
    ['Total Jam', ''],
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
  String totalJam = '';
  String userToken = '';
  String topikPerkuliahan = '';

  Future<void> fetchJadwalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    setState(() {
      userToken = token ?? '';
    });

    print("CekJadwalData : ${widget.jadwalData}");

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
      transposedData[5][1] = widget.jadwalData[6];

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
    print("Kuliah : ${topikPerkuliahan}");
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
                    transposedData[0].map<DataColumn>((dynamic columnValue) {
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
                    .map<DataRow>((List<dynamic> rowData) {
                  return DataRow(
                    cells: rowData.map<DataCell>((dynamic cellValue) {
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
                              setState(() {
                                topikPerkuliahan = value;
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
                    "hari": widget.jadwalData[0],
                    "jam_mulai": widget.jadwalData[7],
                    "jam_akhir": widget.jadwalData[8],
                    "waktu_realisasi": selectedDate.toString(),
                    "ruangan": widget.jadwalData[5],
                    "total_jam": int.parse(widget.jadwalData[6]),
                    "topik_perkuliahan": topikPerkuliahan,
                    "kelas_mk_dosen_id": int.parse(widget.jadwalData[9])
                  };

                  print("CekUserToken $userToken");

                  final response = await http.post(
                    Uri.parse(
                        'http://192.168.0.104:3000/api/aktivasiPerkuliahan'),
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
                                FocusScope.of(context)
                                    .unfocus(); // Unfocus any active input fields
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SchedulePage();
                                }));
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
