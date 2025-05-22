import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uklmusik/screens/song_detail_view.dart';

class SongListScreen extends StatefulWidget {
  final String playlistId;

  const SongListScreen({Key? key, required this.playlistId}) : super(key: key);

  @override
  _SongListScreenState createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  List<dynamic> _songs = []; //mengambil lagu
  bool _isLoading = false; 
  String _error = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  Future<void> _fetchSongs([String search = '']) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      String url =
          'https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song-list/${widget.playlistId}';
      if (search.isNotEmpty) {
        url += '?search=${Uri.encodeComponent(search)}';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _songs = data['data'];
        });
      } else {
        setState(() {
          _error = 'Gagal memuat lagu. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final keyword = _searchController.text.trim();
    _fetchSongs(keyword);
  }

  String getThumbnailUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return '';
    final fileName = Uri.encodeComponent(rawUrl.split('/').last);
    return 'https://learn.smktelkom-mlg.sch.id/ukl2/thumbnail/$fileName';
  }

  Widget _buildSongItem(dynamic song) {
    final thumbnailUrl = getThumbnailUrl(song['thumbnail']);

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
                  child: Icon(Icons.broken_image, color: Colors.white),
                );
              },
            )
          : Container(
              width: 50,
              height: 50,
              color: Color.fromARGB(255, 21, 110, 212),
              child: Icon(Icons.music_note, color: Colors.white),
            ),
      title: Text(song['title'] ?? ''),
      subtitle: Text(song['artist'] ?? ''),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongDetailView(songId: song['uuid']),
          ),
        );
      },
    );
  }       

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Lagu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari judul lagu',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                      ? Center(child: Text(_error, style: TextStyle(color: Colors.red)))
                      : _songs.isEmpty
                          ? Center(child: Text('Lagu tidak ditemukan'))
                          : ListView.separated(
                              itemCount: _songs.length,
                              separatorBuilder: (_, __) => Divider(),
                              itemBuilder: (context, index) {
                                return _buildSongItem(_songs[index]);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
