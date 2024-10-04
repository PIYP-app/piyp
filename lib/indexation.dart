import 'package:flutter/material.dart';
import 'package:piyp/sources.dart';
import 'package:piyp/thumbnail.dart';

class IndexationPage extends StatefulWidget {
  const IndexationPage({super.key});

  @override
  _IndexationPageState createState() => _IndexationPageState();
}

class _IndexationPageState extends State<IndexationPage> {
  final Sources _sources = Sources();
  bool _isIndexing = false;
  int _totalFiles = 0;
  int _processedFiles = 0;

  Future<void> _startIndexation() async {
    setState(() {
      _isIndexing = true;
      _totalFiles = 0;
      _processedFiles = 0;
    });

    try {
      await _sources.retrieveAllFiles();
      final files = _sources.getAllFiles();
      setState(() {
        _totalFiles = files.length;
      });

      for (var i = 0; i < files.length; i += 50) {
        final batch = files.skip(i).take(50);
        await Future.wait(batch.map((file) async {
          file.fileData = await file.server.read(file.path!);
          Thumbnail.getOrCreateThumbnail(file.eTag!, file);
          final newMedia = await file.readExifFromFile();

          await Sources.saveMediaInDatabase(newMedia);

          setState(() {
            _processedFiles++;
          });
        }));
      }
    } catch (e) {
      // Handle errors
      print('Error during indexation: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isIndexing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Indexation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isIndexing)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text('Indexing: $_processedFiles / $_totalFiles'),
                ],
              )
            else
              ElevatedButton(
                onPressed: _startIndexation,
                child: const Text('Start Indexation'),
              ),
          ],
        ),
      ),
    );
  }
}
