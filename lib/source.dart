import 'package:piyp/database/database.dart';

class SourceFile {
  Source server;
  String? path;
  bool? isDir;
  String? name;
  String? mimeType;
  int? size;
  String? eTag;
  DateTime? cTime;
  DateTime? mTime;

  MediaCompanion toCompanion() {
    final fileCompanion = MediaCompanion.insert(
      serverId: server.id,
      eTag: eTag!,
      mimeType: mimeType!,
      pathFile: path!,
      creationDate: mTime!.toIso8601String(),
    );

    return fileCompanion;
  }

  SourceFile({
    required this.server,
    this.path,
    this.isDir,
    this.name,
    this.mimeType,
    this.size,
    this.eTag,
    this.cTime,
    this.mTime,
  });
}

abstract class Source {
  final int id;
  List<SourceFile> files = [];
  bool isErrored = false;

  Source(this.id);

  get username => null;
  get pwd => null;

  String getBaseUrl();

  Future<List<int>> read(String path);
  Future<void> retrieveFileList();
  Future<void> testServerConnection();
}
