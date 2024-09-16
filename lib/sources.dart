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
    print('wut wut');
    List<ServerData> servers = await database.select(database.server).get();

    for (var server in servers) {
      if (server.serverType == ServerType.webdav.value) {
        sources.add(WebdavClient(server.id,
            uri: server.uri,
            username: server.username,
            pwd: server.pwd,
            folderPath: server.folderPath ?? ''));
      }
    }
  }
}
