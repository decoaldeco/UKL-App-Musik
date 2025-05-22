import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SongDetailView extends StatefulWidget {
  final String songId;

  const SongDetailView({super.key, required this.songId});

  @override
  State<SongDetailView> createState() => _SongDetailViewState();
}

class _SongDetailViewState extends State<SongDetailView> {
  Map<String, dynamic>? song;
  bool isLoading = true;
  String? error;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    fetchSongDetail();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> fetchSongDetail() async {
    try {
      final response = await http.get(Uri.parse(
          'https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song/${widget.songId}'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        final videoId = YoutubePlayer.convertUrlToId(data['source']);

        if (videoId != null) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          );
        }

        setState(() {
          song = data;
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil detail lagu');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Lagu"),
        backgroundColor: const Color.fromARGB(255, 21, 110, 212),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song!['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song!['artist'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        if (_youtubeController != null)
                          YoutubePlayer(
                            controller: _youtubeController!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.red,
                              handleColor: Colors.redAccent,
                            ),
                          )
                        else
                          const Text(
                            "Video tidak tersedia atau bukan link YouTube.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        const SizedBox(height: 16),
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(song!['description']),
                        const Divider(height: 30),
                        const Text(
                          "Comments",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...song!['comments'].map<Widget>((comment) {
                          return ListTile(
                            title: Text(comment['creator']),
                            subtitle: Text(comment['comment_text']),
                            trailing: Text(
                              comment['createdAt']
                                  .toString()
                                  .split(' ')
                                  .first,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
    );
  }
}
