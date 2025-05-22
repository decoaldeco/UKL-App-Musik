import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/playlist_screen.dart';
import 'screens/song_list_screen.dart';
import 'screens/add_song_screen.dart';
import 'screens/song_detail_view.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song Playlist App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final username = (args is String) ? args : 'User';
          return DashboardScreen(username: username);
        },
        '/playlists': (context) => PlaylistScreen(),
        '/songs': (context) =>
            SongListScreen(playlistId: ModalRoute.of(context)!.settings.arguments as String),
        '/add-song': (context) => AddSongScreen(),
        '/song-detail': (context) =>
            SongDetailView(songId: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
