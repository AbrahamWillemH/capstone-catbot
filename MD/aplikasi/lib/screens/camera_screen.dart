import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image; // Untuk menyimpan gambar yang dipilih atau diambil
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk mengambil gambar dari kamera
  Future<void> _pickImageFromCamera() async {
  try {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.camera, // Kamera
      maxWidth: 800,             // Ukuran maksimum (opsional)
      maxHeight: 600,            // Ukuran maksimum (opsional)
    );
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  } catch (e) {
    print("Error membuka kamera: $e");
  }
}


  // Fungsi untuk mengambil gambar dari galeri
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamera'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tampilkan gambar yang dipilih atau diambil
            if (_image != null)
              Image.file(
                _image!,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              )
            else
              const Text(
                'Belum ada gambar yang diambil',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol untuk mengambil gambar dari kamera
                ElevatedButton.icon(
                  onPressed: _pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Kamera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 20),
                // Tombol untuk mengambil gambar dari galeri
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeri'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
