import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aplikasi/screens/profil_screen.dart';
import 'package:aplikasi/screens/chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  final String password;

  const HomeScreen({super.key, required this.email, required this.password});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _predictionResult;
  bool _isLoading = false;

  Future<void> _openCamera() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
      );
      if (pickedImage != null) {
        Uint8List bytes = await pickedImage.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _predictionResult = null;
        });
        await _uploadImageAndPredict(bytes);
      }
    } catch (e) {
      _showErrorDialog("Gagal membuka kamera: $e");
    }
  }

  Future<void> _uploadImageAndPredict(Uint8List imageBytes) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var uri = Uri.parse('http://34.28.27.190:5000/predict');
      var request = http.MultipartRequest('POST', uri);
      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'uploaded_image.jpg',
      );
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var predictions = _parsePredictions(jsonResponse);

        setState(() {
          _predictionResult =
              "Disease: ${predictions['class']}\nConfidence: ${predictions['confidence']}%";
        });
      } else {
        throw Exception('Gagal melakukan prediksi: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog("Gagal mengunggah gambar: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _parsePredictions(Map<String, dynamic> jsonResponse) {
    var prediction = jsonResponse['predictions'][0];
    int classId = prediction['class'];
    double confidence = prediction['confidence'];

    String classLabel = _getClassLabel(classId);

    return {
      'class': classLabel,
      'confidence': confidence.toStringAsFixed(2),
    };
  }

  String _getClassLabel(int classId) {
    switch (classId) {
      case 0:
        return "Dermatitis";
      case 1:
        return "Eye sickness";  
      case 2:
        return "Eye Normal";  
      case 3:
        return "Hairloss";  
      case 4:
        return "Lump and bump";  
      case 5:
        return "Scabies";
      default:
        return "Unknown";
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Halaman Utama'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFFD0F0C0)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Sistem Deteksi Penyakit Kucing',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (_imageBytes != null)
                  Image.memory(
                    _imageBytes!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                if (_isLoading) const CircularProgressIndicator(),
                if (_predictionResult != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _predictionResult!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 7, 94, 84),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              _openCamera();
              break;
            case 1:
              // Navigating to ChatBotScreen and immediately triggering a conversation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatBotScreen(),
                ),
              ).then((_) {
                // Optionally, you can add additional logic after the chatbot screen is closed
              });
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    email: widget.email,
                    username: widget.password,
                    phoneNumber: '081234567890',
                    photoUrl: 'https://example.com/profile.jpg',
                    dateOfBirth: '01-01-1990',
                    address: 'Jakarta, Indonesia',
                    profession: 'Developer',
                  ),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Unggah File',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat Bot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
