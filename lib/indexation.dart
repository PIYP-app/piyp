import 'package:flutter/material.dart';
import 'package:piyp/sources.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/init_db.dart';

class IndexationPage extends StatefulWidget {
  const IndexationPage({super.key});

  @override
  State<IndexationPage> createState() => _IndexationPageState();
}

class _IndexationPageState extends State<IndexationPage> {
  bool isIndexing = false;
  String statusText = '';
  int totalFiles = 0;
  int processedFiles = 0;

  Future<void> startIndexation() async {
    setState(() {
      isIndexing = true;
      statusText = 'Starting indexation...';
      totalFiles = 0;
      processedFiles = 0;
    });

    try {
      Sources sources = Sources();
      await sources.connectAllSources();

      setState(() {
        statusText = 'Connected to sources. Retrieving files...';
      });

      await sources.retrieveAllFiles();
      final List<MediaCompanion> files =
          sources.getAllFiles().map((file) => file.toCompanion()).toList();

      setState(() {
        totalFiles = files.length;
        statusText = 'Found $totalFiles files. Processing...';
      });

      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        await database.insertMediaOnConflictUpdateEtag(
          file.serverId.value,
          file.eTag.value,
          file.mimeType.value,
          file.pathFile.value,
          file.creationDate.value,
          file.latitude.value,
          file.longitude.value,
        );

        setState(() {
          processedFiles = i + 1;
          statusText = 'Processing file $processedFiles/$totalFiles';
        });
      }

      setState(() {
        statusText = 'Indexation completed successfully!';
        isIndexing = false;
      });
    } catch (e) {
      setState(() {
        statusText = 'Error during indexation: $e';
        isIndexing = false;
      });
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
            if (isIndexing)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(statusText),
                ],
              )
            else
              ElevatedButton(
                onPressed: startIndexation,
                child: const Text('Start Indexation'),
              ),
          ],
        ),
      ),
    );
  }
}
