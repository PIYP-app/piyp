import 'package:webdav_client/webdav_client.dart';

Client? globalClient;

class WebdavClient {
  static final _webdavClient = WebdavClient._internal();
  late Client client;
  List<File> files = [];

  factory WebdavClient() {
    return _webdavClient;
  }

  WebdavClient._internal();
}
