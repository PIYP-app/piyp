class SourceFile {
  String? path;
  bool? isDir;
  String? name;
  String? mimeType;
  int? size;
  String? eTag;
  DateTime? cTime;
  DateTime? mTime;

  SourceFile({
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

  Source(this.id);

  Future<List<int>> read(String path);
  Future<void> retrieveFileList();
}
