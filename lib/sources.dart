import 'package:drift/drift.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/enum.dart';
import 'package:piyp/init_db.dart';
import 'package:piyp/source.dart';
import 'package:piyp/webdav_client.dart';

class Sources {
  static final _sources = Sources._internal();
  List<Source> sources = [];

  factory Sources() {
    return _sources;
  }

  Sources._internal();

  Future<void> connectAllSources() async {
    List<ServerData> servers = await database.select(database.server).get();

    for (var server in servers) {
      if (server.serverType == ServerType.webdav.value) {
        final newClient = WebdavClient(server.id,
            uri: server.uri,
            username: server.username,
            pwd: server.pwd,
            folderPath: server.folderPath ?? '');

        await newClient.testServerConnection();

        if (newClient.isErrored) {
          return;
        }

        if (sources.indexWhere((source) => source.id == server.id) != -1) {
          return;
        }

        sources.add(WebdavClient(server.id,
            uri: server.uri,
            username: server.username,
            pwd: server.pwd,
            folderPath: server.folderPath ?? ''));
      }
    }
  }

  Future<void> retrieveAllFiles() async {
    final List<Future<void>> sourcesFileRetrieve = sources.map((source) {
      return source.retrieveFileList();
    }).toList();

    await Future.wait(sourcesFileRetrieve);
  }

  List<SourceFile> getAllFiles() {
    List<SourceFile> files = [];
    for (var source in sources) {
      files.addAll(source.files);
    }

    files.sort((a, b) => b.mTime!.compareTo(a.mTime!));

    return files;
  }
}
