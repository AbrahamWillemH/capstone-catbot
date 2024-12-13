import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String email; // Data email dari login
  final String username; // Username pengguna
  final String phoneNumber; // Nomor telepon pengguna
  final String photoUrl; // URL Foto profil pengguna
  final String dateOfBirth; // Tanggal lahir
  final String address; // Alamat pengguna
  final String profession; // Pekerjaan pengguna

  const ProfileScreen({
    super.key,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.dateOfBirth,
    required this.address,
    required this.profession,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _addressController;
  late TextEditingController _professionController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data yang ada
    _emailController = TextEditingController(text: widget.email);
    _usernameController = TextEditingController(text: widget.username);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _dateOfBirthController = TextEditingController(text: widget.dateOfBirth);
    _addressController = TextEditingController(text: widget.address);
    _professionController = TextEditingController(text: widget.profession);
  }

  @override
  void dispose() {
    // Jangan lupa untuk dispose controller saat layar dihapus
    _emailController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Profil Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Edit Profil Pengguna',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildProfilePicture(),
            const SizedBox(height: 20),
            _buildTextField('Email', _emailController),
            const SizedBox(height: 10),
            _buildTextField('Username', _usernameController),
            const SizedBox(height: 10),
            _buildTextField('Nomor Telepon', _phoneNumberController),
            const SizedBox(height: 10),
            _buildTextField('Tanggal Lahir', _dateOfBirthController),
            const SizedBox(height: 10),
            _buildTextField('Alamat', _addressController),
            const SizedBox(height: 10),
            _buildTextField('Pekerjaan', _professionController),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Simpan perubahan dan kembali
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Simpan Perubahan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(widget.photoUrl),
        backgroundColor: Colors.grey[300],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
