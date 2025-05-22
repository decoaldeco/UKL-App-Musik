import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddSongScreen extends StatefulWidget {
  @override
  _AddSongScreenState createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _artist = '';
  String _description = '';
  String _thumbnailUrl = ''; 
  String? _selectedFileName; 

  Future<void> _addSong() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await http.post(
      Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': _title,
        'artist': _artist,
        'description': _description,
        'thumbnail': _thumbnailUrl,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lagu berhasil ditambahkan!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan lagu. Kode status: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Lagu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan judul lagu';
                  }
                  return null;
                },
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Artis'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nama artis';
                  }
                  return null;
                },
                onChanged: (value) {
                  _artist = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan deskripsi lagu';
                  }
                  return null;
                },
                onChanged: (value) {
                  _description = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'URL Thumbnail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan URL thumbnail';
                  }
                  return null;
                },
                onChanged: (value) {
                  _thumbnailUrl = value;
                },
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  const Text('Thumbnail'),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedFileName = 'gambar_terpilih.jpg';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tidak bisa.')),
                      );
                    },
                    child: const Text('Pilih File'),
                  ),
                  const SizedBox(width: 10),
                  Text(_selectedFileName ?? 'Tidak ada file yang dipilih'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addSong();
                  }
                },
                child: const Text('Tambah Lagu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
