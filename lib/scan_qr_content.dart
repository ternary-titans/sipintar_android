import 'package:flutter/material.dart';
import 'package:presensi_mahasiswa/recap_content.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
        },
      ),
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
  bool isCameraPaused = false;
  String userToken = '';

  int mahasiswaId = -1;

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

        sendDataToEndpoint(result);
        _showSuccessDialog(result);
        controller.pauseCamera();
      }
    });
  }

  void sendDataToEndpoint(Barcode qrCodeData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefsMhsId = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    int? mhsId = prefsMhsId.getInt('mhs_id');
    setState(() {
      userToken = token ?? '';
      mahasiswaId = mhsId ?? 0;
    });
    final String apiUrl = 'http://192.168.0.104:3000/api/presensi';

    Map<String, dynamic> requestBody = {
      'mahasiswa_id': mahasiswaId, // Replace with the actual mahasiswa_id
      'waktu_presensi': DateTime.now().toUtc().toIso8601String(),
      'token': qrCodeData.code,
      // Add other data you want to send to the endpoint
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json', "Authorization": userToken},
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
    print("Cek Decode Token : $decodedToken");
    print("Cek Token : $jwtToken");
    await showDialog(
      context: context,
      barrierDismissible: false,
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
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Hentikan kamera setelah berhasil mendapatkan hasil scan
                controller?.resumeCamera();
                // Navigasi ke RecapPage
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
