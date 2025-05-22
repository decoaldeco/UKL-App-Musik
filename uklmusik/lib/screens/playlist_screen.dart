import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<dynamic> _playlists = [];

  @override
  void initState() {
    super.initState();
    _fetchPlaylists();
  }
  // mengambil data

  Future<void> _fetchPlaylists() async {
    final response = await http.get(Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl2/playlists'));

    if (response.statusCode == 200) {
      setState(() {
        _playlists = json.decode(response.body)['data'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load playlists')),
      );
    }
  }

  String getThumbnailUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return '';
    final fileName = Uri.encodeComponent(rawUrl.split('/').last);
    return 'https://learn.smktelkom-mlg.sch.id/ukl2/thumbnail/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlists')),
      body: ListView.builder(
        itemCount: _playlists.length,
        itemBuilder: (context, index) {
          final playlist = _playlists[index];
          final thumbnailUrl = getThumbnailUrl(playlist['thumbnail']);

          return ListTile(
            leading: thumbnailUrl.isNotEmpty
                ? Image.network(
                    thumbnailUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        color: Color.fromARGB(255, 21, 110, 212),
                        child: Icon(Icons.image_not_supported, color: Colors.white),
                      );
                    },
                  )
                : Container(
                    width: 50,
                    height: 50,
                    color: Color.fromARGB(255, 21, 110, 212),
                    child: Icon(Icons.music_note, color: Colors.white),
                  ),
            title: Text(playlist['playlist_name']),
            subtitle: Text('Songs: ${playlist['song_count']}'),
            onTap: () {
              Navigator.pushNamed(context, '/songs', arguments: playlist['uuid']);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-song');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
