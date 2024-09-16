import 'package:piyp/source.dart';
import 'package:webdav_client/webdav_client.dart';

class WebdavClient extends Source {
  late Client client;
  final String uri;
  final String username;
  final String pwd;
  final String folderPath;

  WebdavClient(super.id,
      {required this.uri,
      required this.username,
      required this.pwd,
      required this.folderPath}) {
    initClient(uri, username, pwd, folderPath);
  }

  initClient(String uri, String username, String pwd, String folderPath) async {
    client = Client(
      uri: uri,
      c: WdDio(),
      auth: BasicAuth(user: username, pwd: pwd),
    );
  }

  @override
  Future<void> retrieveFileList() async {
    client.setHeaders({'Accept-Charset': 'utf-8'});
    client.setConnectTimeout(15000);
    client.setSendTimeout(15000);
    client.setReceiveTimeout(15000);

    var list = await client.readDir(folderPath);

    list.removeWhere((element) =>
        !element.mimeType!.contains('video') &&
        !element.mimeType!.contains('image'));
    files = list.map((toElement) {
      return SourceFile(
        path: toElement.name,
        isDir: toElement.isDir,
        name: toElement.name,
        mimeType: toElement.mimeType,
        size: toElement.size,
        eTag: toElement.eTag,
        cTime: toElement.cTime,
        mTime: toElement.mTime,
      );
    }).toList();
    files.sort((a, b) => b.mTime!.compareTo(a.mTime!));
  }

  @override
  Future<List<int>> read(String path) async {
    var file =
        await client.read((folderPath != '' ? '$folderPath/' : '') + path);

    return file;
  }
}
