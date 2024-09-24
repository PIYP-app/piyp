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
