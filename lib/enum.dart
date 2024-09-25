enum ServerType {
  webdav('webdav');

  final String value;
  const ServerType(this.value);
}

enum MediaMimeType {
  video('video'),
  image('image');

  final String value;
  const MediaMimeType(this.value);
}
