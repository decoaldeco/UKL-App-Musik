import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  const DashboardScreen({Key? key, required this.username}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)!.settings.arguments as String? ?? 'User';
    

    return Scaffold(
      backgroundColor: Color(0xFFF5FFF7),
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color.fromARGB(255, 21, 110, 212),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.headphones_rounded, size: 100, color: Color.fromARGB(255, 21, 110, 212)),
              SizedBox(height: 20),
              Text(
                'Selamat Datang, $username!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Nikmati musikmu!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                icon: Icon(Icons.library_music),
                label: Text('Lihat Song Playlist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.pushNamed(context, '/playlists');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 21, 110, 212),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
