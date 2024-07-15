// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlbumFetcherWidget extends StatefulWidget {
  const AlbumFetcherWidget({super.key, required this.onAlbumSelected});

  final Future<void> Function(String?) onAlbumSelected;

  @override
  State<AlbumFetcherWidget> createState() => _AlbumFetcherWidgetState();
}

class _AlbumFetcherWidgetState extends State<AlbumFetcherWidget> {
  List<Map<String, String>> _albums = [];
  var channel = const MethodChannel('com.example.winter/native');

  Future<void> _fetchAlbums() async {
    try {
      final List<dynamic> result = await channel.invokeMethod('GetAllAlbums');
      setState(() {
        _albums = result.map((e) => Map<String, String>.from(e)).toList();
      });
    } on PlatformException catch (e) {
      print("Failed to fetch albums: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => widget.onAlbumSelected(_albums[index]['title']!),
          title: Text(_albums[index]['title'] ?? 'No title'),
        );
      },
    );
  }
}
