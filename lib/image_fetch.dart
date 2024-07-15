import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_call_native/album_fetch.dart';

class ImageFetcherWidget extends StatefulWidget {
  const ImageFetcherWidget({
    super.key,
  });

  @override
  State<ImageFetcherWidget> createState() => _ImageFetcherWidgetState();
}

class _ImageFetcherWidgetState extends State<ImageFetcherWidget> {
  List<Uint8List> _imageDataList = [];
  var channel = const MethodChannel('com.example.winter/native');

  Future<void> _fetchImages(String? albumName) async {
    try {
      final List<dynamic> result = await channel
          .invokeMethod('GetImagesFromAlbums', {'albumName': albumName ?? 'Winter'});
      setState(() {
        _imageDataList = result.cast<Uint8List>();
      });
    } on PlatformException catch (e) {
      print("Failed to fetch images: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchImages('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 200, child: AlbumFetcherWidget(
            onAlbumSelected: _fetchImages,
        )),
        Expanded(
            child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 3, crossAxisSpacing: 3),
          itemCount: _imageDataList.length,
          itemBuilder: (context, index) {
            return Image.memory(
              _imageDataList[index],
              fit: BoxFit.cover,
            );
          },
        ))
      ],
    );
  }
}
