import 'package:flutter/material.dart';
import 'package:presensi_mahasiswa/aktivitas_content.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

    var url = Uri.parse('http://192.168.0.104:3000/api/users/current');
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
    [
      'Hari',
      'Waktu',
      'Kode Matkul',
      'Matkul',
      'Dosen',
      'Ruangan',
      'Total Jam',
      'Jam Mulai',
      'Jam Akhir',
      'Kelas MK Dosen Id',
      'Aksi'
    ],
  ];
  List<String> secondTableHeader = [
    'Hari',
    'Waktu',
    'Kode Matkul',
    'Matkul',
    'Dosen',
    'Ruangan',
    'Total Jam',
    'Jam Mulai',
    'Jam Akhir',
    'Kelas MK Dosen Id',
    'Aksi',
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
        Uri.parse('http://192.168.0.104:3000/api/mahasiswa/$mhsId/jadwal');
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
          jadwal['total_jam'].toString(),
          jadwal['jam_mulai'],
          jadwal['jam_akhir'],
          jadwal['kelas_mk_dosen_id'].toString(),
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
                  columns: secondTableHeader
                      .asMap()
                      .entries
                      .where((entry) =>
                          entry.key < 6 ||
                          entry.key > 9) // Exclude columns with index 6 to 9
                      .map<DataColumn>((entry) {
                    int columnIndex = entry.key;
                    String columnValue = entry.value;
                    return DataColumn(
                      label: Container(
                        width: 100,
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
                      cells: rowData
                          .asMap()
                          .entries
                          .where((entry) =>
                              entry.key < 6 ||
                              entry.key > 9) // Exclude cells with index 6 to 9
                          .map<DataCell>((entry) {
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
                              width: 100,
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
