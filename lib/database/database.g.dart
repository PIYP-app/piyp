// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Server extends Table with TableInfo<Server, ServerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Server(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _serverTypeMeta =
      const VerificationMeta('serverType');
  late final GeneratedColumn<String> serverType = GeneratedColumn<String>(
      'serverType', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL CHECK (serverType IN (\'webdav\'))');
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE');
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _pwdMeta = const VerificationMeta('pwd');
  late final GeneratedColumn<String> pwd = GeneratedColumn<String>(
      'pwd', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _folderPathMeta =
      const VerificationMeta('folderPath');
  late final GeneratedColumn<String> folderPath = GeneratedColumn<String>(
      'folder_path', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns =>
      [id, serverType, title, uri, username, pwd, folderPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Server';
  @override
  VerificationContext validateIntegrity(Insertable<ServerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('serverType')) {
      context.handle(
          _serverTypeMeta,
          serverType.isAcceptableOrUnknown(
              data['serverType']!, _serverTypeMeta));
    } else if (isInserting) {
      context.missing(_serverTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('pwd')) {
      context.handle(
          _pwdMeta, pwd.isAcceptableOrUnknown(data['pwd']!, _pwdMeta));
    } else if (isInserting) {
      context.missing(_pwdMeta);
    }
    if (data.containsKey('folder_path')) {
      context.handle(
          _folderPathMeta,
          folderPath.isAcceptableOrUnknown(
              data['folder_path']!, _folderPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serverType'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      pwd: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pwd'])!,
      folderPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_path']),
    );
  }

  @override
  Server createAlias(String alias) {
    return Server(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ServerData extends DataClass implements Insertable<ServerData> {
  final int id;
  final String serverType;
  final String title;
  final String uri;
  final String username;
  final String pwd;
  final String? folderPath;
  const ServerData(
      {required this.id,
      required this.serverType,
      required this.title,
      required this.uri,
      required this.username,
      required this.pwd,
      this.folderPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['serverType'] = Variable<String>(serverType);
    map['title'] = Variable<String>(title);
    map['uri'] = Variable<String>(uri);
    map['username'] = Variable<String>(username);
    map['pwd'] = Variable<String>(pwd);
    if (!nullToAbsent || folderPath != null) {
      map['folder_path'] = Variable<String>(folderPath);
    }
    return map;
  }

  ServerCompanion toCompanion(bool nullToAbsent) {
    return ServerCompanion(
      id: Value(id),
      serverType: Value(serverType),
      title: Value(title),
      uri: Value(uri),
      username: Value(username),
      pwd: Value(pwd),
      folderPath: folderPath == null && nullToAbsent
          ? const Value.absent()
          : Value(folderPath),
    );
  }

  factory ServerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerData(
      id: serializer.fromJson<int>(json['id']),
      serverType: serializer.fromJson<String>(json['serverType']),
      title: serializer.fromJson<String>(json['title']),
      uri: serializer.fromJson<String>(json['uri']),
      username: serializer.fromJson<String>(json['username']),
      pwd: serializer.fromJson<String>(json['pwd']),
      folderPath: serializer.fromJson<String?>(json['folder_path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverType': serializer.toJson<String>(serverType),
      'title': serializer.toJson<String>(title),
      'uri': serializer.toJson<String>(uri),
      'username': serializer.toJson<String>(username),
      'pwd': serializer.toJson<String>(pwd),
      'folder_path': serializer.toJson<String?>(folderPath),
    };
  }

  ServerData copyWith(
          {int? id,
          String? serverType,
          String? title,
          String? uri,
          String? username,
          String? pwd,
          Value<String?> folderPath = const Value.absent()}) =>
      ServerData(
        id: id ?? this.id,
        serverType: serverType ?? this.serverType,
        title: title ?? this.title,
        uri: uri ?? this.uri,
        username: username ?? this.username,
        pwd: pwd ?? this.pwd,
        folderPath: folderPath.present ? folderPath.value : this.folderPath,
      );
  ServerData copyWithCompanion(ServerCompanion data) {
    return ServerData(
      id: data.id.present ? data.id.value : this.id,
      serverType:
          data.serverType.present ? data.serverType.value : this.serverType,
      title: data.title.present ? data.title.value : this.title,
      uri: data.uri.present ? data.uri.value : this.uri,
      username: data.username.present ? data.username.value : this.username,
      pwd: data.pwd.present ? data.pwd.value : this.pwd,
      folderPath:
          data.folderPath.present ? data.folderPath.value : this.folderPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerData(')
          ..write('id: $id, ')
          ..write('serverType: $serverType, ')
          ..write('title: $title, ')
          ..write('uri: $uri, ')
          ..write('username: $username, ')
          ..write('pwd: $pwd, ')
          ..write('folderPath: $folderPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, serverType, title, uri, username, pwd, folderPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerData &&
          other.id == this.id &&
          other.serverType == this.serverType &&
          other.title == this.title &&
          other.uri == this.uri &&
          other.username == this.username &&
          other.pwd == this.pwd &&
          other.folderPath == this.folderPath);
}

class ServerCompanion extends UpdateCompanion<ServerData> {
  final Value<int> id;
  final Value<String> serverType;
  final Value<String> title;
  final Value<String> uri;
  final Value<String> username;
  final Value<String> pwd;
  final Value<String?> folderPath;
  const ServerCompanion({
    this.id = const Value.absent(),
    this.serverType = const Value.absent(),
    this.title = const Value.absent(),
    this.uri = const Value.absent(),
    this.username = const Value.absent(),
    this.pwd = const Value.absent(),
    this.folderPath = const Value.absent(),
  });
  ServerCompanion.insert({
    this.id = const Value.absent(),
    required String serverType,
    required String title,
    required String uri,
    required String username,
    required String pwd,
    this.folderPath = const Value.absent(),
  })  : serverType = Value(serverType),
        title = Value(title),
        uri = Value(uri),
        username = Value(username),
        pwd = Value(pwd);
  static Insertable<ServerData> custom({
    Expression<int>? id,
    Expression<String>? serverType,
    Expression<String>? title,
    Expression<String>? uri,
    Expression<String>? username,
    Expression<String>? pwd,
    Expression<String>? folderPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverType != null) 'serverType': serverType,
      if (title != null) 'title': title,
      if (uri != null) 'uri': uri,
      if (username != null) 'username': username,
      if (pwd != null) 'pwd': pwd,
      if (folderPath != null) 'folder_path': folderPath,
    });
  }

  ServerCompanion copyWith(
      {Value<int>? id,
      Value<String>? serverType,
      Value<String>? title,
      Value<String>? uri,
      Value<String>? username,
      Value<String>? pwd,
      Value<String?>? folderPath}) {
    return ServerCompanion(
      id: id ?? this.id,
      serverType: serverType ?? this.serverType,
      title: title ?? this.title,
      uri: uri ?? this.uri,
      username: username ?? this.username,
      pwd: pwd ?? this.pwd,
      folderPath: folderPath ?? this.folderPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverType.present) {
      map['serverType'] = Variable<String>(serverType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (pwd.present) {
      map['pwd'] = Variable<String>(pwd.value);
    }
    if (folderPath.present) {
      map['folder_path'] = Variable<String>(folderPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerCompanion(')
          ..write('id: $id, ')
          ..write('serverType: $serverType, ')
          ..write('title: $title, ')
          ..write('uri: $uri, ')
          ..write('username: $username, ')
          ..write('pwd: $pwd, ')
          ..write('folderPath: $folderPath')
          ..write(')'))
        .toString();
  }
}

class Places extends Table with TableInfo<Places, Place> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Places(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: 'NOT NULL DEFAULT CURRENT_TIMESTAMP',
      defaultValue: const CustomExpression('CURRENT_TIMESTAMP'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, latitude, longitude, country, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Places';
  @override
  VerificationContext validateIntegrity(Insertable<Place> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Place map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Place(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  Places createAlias(String alias) {
    return Places(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Place extends DataClass implements Insertable<Place> {
  final String? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String createdAt;
  const Place(
      {this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      this.country,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    map['name'] = Variable<String>(name);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      createdAt: Value(createdAt),
    );
  }

  factory Place.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Place(
      id: serializer.fromJson<String?>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      country: serializer.fromJson<String?>(json['country']),
      createdAt: serializer.fromJson<String>(json['created_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'country': serializer.toJson<String?>(country),
      'created_at': serializer.toJson<String>(createdAt),
    };
  }

  Place copyWith(
          {Value<String?> id = const Value.absent(),
          String? name,
          double? latitude,
          double? longitude,
          Value<String?> country = const Value.absent(),
          String? createdAt}) =>
      Place(
        id: id.present ? id.value : this.id,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        country: country.present ? country.value : this.country,
        createdAt: createdAt ?? this.createdAt,
      );
  Place copyWithCompanion(PlacesCompanion data) {
    return Place(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      country: data.country.present ? data.country.value : this.country,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Place(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('country: $country, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, latitude, longitude, country, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Place &&
          other.id == this.id &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.country == this.country &&
          other.createdAt == this.createdAt);
}

class PlacesCompanion extends UpdateCompanion<Place> {
  final Value<String?> id;
  final Value<String> name;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> country;
  final Value<String> createdAt;
  final Value<int> rowid;
  const PlacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.country = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double latitude,
    required double longitude,
    this.country = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        latitude = Value(latitude),
        longitude = Value(longitude);
  static Insertable<Place> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? country,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (country != null) 'country': country,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesCompanion copyWith(
      {Value<String?>? id,
      Value<String>? name,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String?>? country,
      Value<String>? createdAt,
      Value<int>? rowid}) {
    return PlacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('country: $country, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Media extends Table with TableInfo<Media, MediaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Media(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'PRIMARY KEY AUTOINCREMENT');
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'serverId', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _eTagMeta = const VerificationMeta('eTag');
  late final GeneratedColumn<String> eTag = GeneratedColumn<String>(
      'eTag', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL UNIQUE ON CONFLICT REPLACE');
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mimeType', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL CHECK (mimeType IN (\'image\', \'video\'))');
  static const VerificationMeta _pathFileMeta =
      const VerificationMeta('pathFile');
  late final GeneratedColumn<String> pathFile = GeneratedColumn<String>(
      'pathFile', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _creationDateMeta =
      const VerificationMeta('creationDate');
  late final GeneratedColumn<String> creationDate = GeneratedColumn<String>(
      'creationDate', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      $customConstraints: '');
  static const VerificationMeta _placeIdMeta =
      const VerificationMeta('placeId');
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
      'placeId', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      $customConstraints: '');
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        eTag,
        mimeType,
        pathFile,
        creationDate,
        latitude,
        longitude,
        placeId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'Media';
  @override
  VerificationContext validateIntegrity(Insertable<MediaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('serverId')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['serverId']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('eTag')) {
      context.handle(
          _eTagMeta, eTag.isAcceptableOrUnknown(data['eTag']!, _eTagMeta));
    } else if (isInserting) {
      context.missing(_eTagMeta);
    }
    if (data.containsKey('mimeType')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mimeType']!, _mimeTypeMeta));
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('pathFile')) {
      context.handle(_pathFileMeta,
          pathFile.isAcceptableOrUnknown(data['pathFile']!, _pathFileMeta));
    } else if (isInserting) {
      context.missing(_pathFileMeta);
    }
    if (data.containsKey('creationDate')) {
      context.handle(
          _creationDateMeta,
          creationDate.isAcceptableOrUnknown(
              data['creationDate']!, _creationDateMeta));
    } else if (isInserting) {
      context.missing(_creationDateMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('placeId')) {
      context.handle(_placeIdMeta,
          placeId.isAcceptableOrUnknown(data['placeId']!, _placeIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}serverId'])!,
      eTag: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}eTag'])!,
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mimeType'])!,
      pathFile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pathFile'])!,
      creationDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creationDate'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      placeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}placeId']),
    );
  }

  @override
  Media createAlias(String alias) {
    return Media(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
        'FOREIGN KEY(serverId)REFERENCES Server(id)',
        'FOREIGN KEY(placeId)REFERENCES Places(id)'
      ];
  @override
  bool get dontWriteConstraints => true;
}

class MediaData extends DataClass implements Insertable<MediaData> {
  final int id;
  final int serverId;
  final String eTag;
  final String mimeType;
  final String pathFile;
  final String creationDate;
  final double? latitude;
  final double? longitude;
  final String? placeId;
  const MediaData(
      {required this.id,
      required this.serverId,
      required this.eTag,
      required this.mimeType,
      required this.pathFile,
      required this.creationDate,
      this.latitude,
      this.longitude,
      this.placeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['serverId'] = Variable<int>(serverId);
    map['eTag'] = Variable<String>(eTag);
    map['mimeType'] = Variable<String>(mimeType);
    map['pathFile'] = Variable<String>(pathFile);
    map['creationDate'] = Variable<String>(creationDate);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || placeId != null) {
      map['placeId'] = Variable<String>(placeId);
    }
    return map;
  }

  MediaCompanion toCompanion(bool nullToAbsent) {
    return MediaCompanion(
      id: Value(id),
      serverId: Value(serverId),
      eTag: Value(eTag),
      mimeType: Value(mimeType),
      pathFile: Value(pathFile),
      creationDate: Value(creationDate),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      placeId: placeId == null && nullToAbsent
          ? const Value.absent()
          : Value(placeId),
    );
  }

  factory MediaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int>(json['serverId']),
      eTag: serializer.fromJson<String>(json['eTag']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      pathFile: serializer.fromJson<String>(json['pathFile']),
      creationDate: serializer.fromJson<String>(json['creationDate']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      placeId: serializer.fromJson<String?>(json['placeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int>(serverId),
      'eTag': serializer.toJson<String>(eTag),
      'mimeType': serializer.toJson<String>(mimeType),
      'pathFile': serializer.toJson<String>(pathFile),
      'creationDate': serializer.toJson<String>(creationDate),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'placeId': serializer.toJson<String?>(placeId),
    };
  }

  MediaData copyWith(
          {int? id,
          int? serverId,
          String? eTag,
          String? mimeType,
          String? pathFile,
          String? creationDate,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<String?> placeId = const Value.absent()}) =>
      MediaData(
        id: id ?? this.id,
        serverId: serverId ?? this.serverId,
        eTag: eTag ?? this.eTag,
        mimeType: mimeType ?? this.mimeType,
        pathFile: pathFile ?? this.pathFile,
        creationDate: creationDate ?? this.creationDate,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        placeId: placeId.present ? placeId.value : this.placeId,
      );
  MediaData copyWithCompanion(MediaCompanion data) {
    return MediaData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      eTag: data.eTag.present ? data.eTag.value : this.eTag,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      pathFile: data.pathFile.present ? data.pathFile.value : this.pathFile,
      creationDate: data.creationDate.present
          ? data.creationDate.value
          : this.creationDate,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('eTag: $eTag, ')
          ..write('mimeType: $mimeType, ')
          ..write('pathFile: $pathFile, ')
          ..write('creationDate: $creationDate, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('placeId: $placeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverId, eTag, mimeType, pathFile,
      creationDate, latitude, longitude, placeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.eTag == this.eTag &&
          other.mimeType == this.mimeType &&
          other.pathFile == this.pathFile &&
          other.creationDate == this.creationDate &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.placeId == this.placeId);
}

class MediaCompanion extends UpdateCompanion<MediaData> {
  final Value<int> id;
  final Value<int> serverId;
  final Value<String> eTag;
  final Value<String> mimeType;
  final Value<String> pathFile;
  final Value<String> creationDate;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> placeId;
  const MediaCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.eTag = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.pathFile = const Value.absent(),
    this.creationDate = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.placeId = const Value.absent(),
  });
  MediaCompanion.insert({
    this.id = const Value.absent(),
    required int serverId,
    required String eTag,
    required String mimeType,
    required String pathFile,
    required String creationDate,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.placeId = const Value.absent(),
  })  : serverId = Value(serverId),
        eTag = Value(eTag),
        mimeType = Value(mimeType),
        pathFile = Value(pathFile),
        creationDate = Value(creationDate);
  static Insertable<MediaData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<String>? eTag,
    Expression<String>? mimeType,
    Expression<String>? pathFile,
    Expression<String>? creationDate,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? placeId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'serverId': serverId,
      if (eTag != null) 'eTag': eTag,
      if (mimeType != null) 'mimeType': mimeType,
      if (pathFile != null) 'pathFile': pathFile,
      if (creationDate != null) 'creationDate': creationDate,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (placeId != null) 'placeId': placeId,
    });
  }

  MediaCompanion copyWith(
      {Value<int>? id,
      Value<int>? serverId,
      Value<String>? eTag,
      Value<String>? mimeType,
      Value<String>? pathFile,
      Value<String>? creationDate,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<String?>? placeId}) {
    return MediaCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      eTag: eTag ?? this.eTag,
      mimeType: mimeType ?? this.mimeType,
      pathFile: pathFile ?? this.pathFile,
      creationDate: creationDate ?? this.creationDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['serverId'] = Variable<int>(serverId.value);
    }
    if (eTag.present) {
      map['eTag'] = Variable<String>(eTag.value);
    }
    if (mimeType.present) {
      map['mimeType'] = Variable<String>(mimeType.value);
    }
    if (pathFile.present) {
      map['pathFile'] = Variable<String>(pathFile.value);
    }
    if (creationDate.present) {
      map['creationDate'] = Variable<String>(creationDate.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (placeId.present) {
      map['placeId'] = Variable<String>(placeId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('eTag: $eTag, ')
          ..write('mimeType: $mimeType, ')
          ..write('pathFile: $pathFile, ')
          ..write('creationDate: $creationDate, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('placeId: $placeId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final Server server = Server(this);
  late final Places places = Places(this);
  late final Media media = Media(this);
  Future<int> insertMediaOnConflictUpdateEtag(
      int var1,
      String var2,
      String var3,
      String var4,
      String var5,
      double? var6,
      double? var7,
      String? var8) {
    return customInsert(
      'INSERT INTO Media (serverId, eTag, mimeType, pathFile, creationDate, latitude, longitude, placeId) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8) ON CONFLICT (eTag) DO UPDATE SET serverId = excluded.serverId, eTag = excluded.eTag, mimeType = excluded.mimeType, pathFile = excluded.pathFile, creationDate = excluded.creationDate, latitude = excluded.latitude, longitude = excluded.longitude, placeId = excluded.placeId',
      variables: [
        Variable<int>(var1),
        Variable<String>(var2),
        Variable<String>(var3),
        Variable<String>(var4),
        Variable<String>(var5),
        Variable<double>(var6),
        Variable<double>(var7),
        Variable<String>(var8)
      ],
      updates: {media},
    );
  }

  Future<int> insertOrUpdatePlace(
      String? var1, String var2, double var3, double var4, String? var5) {
    return customInsert(
      'INSERT INTO Places (id, name, latitude, longitude, country) VALUES (?1, ?2, ?3, ?4, ?5) ON CONFLICT (id) DO UPDATE SET name = excluded.name, latitude = excluded.latitude, longitude = excluded.longitude, country = excluded.country',
      variables: [
        Variable<String>(var1),
        Variable<String>(var2),
        Variable<double>(var3),
        Variable<double>(var4),
        Variable<String>(var5)
      ],
      updates: {places},
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [server, places, media];
}

typedef $ServerCreateCompanionBuilder = ServerCompanion Function({
  Value<int> id,
  required String serverType,
  required String title,
  required String uri,
  required String username,
  required String pwd,
  Value<String?> folderPath,
});
typedef $ServerUpdateCompanionBuilder = ServerCompanion Function({
  Value<int> id,
  Value<String> serverType,
  Value<String> title,
  Value<String> uri,
  Value<String> username,
  Value<String> pwd,
  Value<String?> folderPath,
});

class $ServerFilterComposer extends FilterComposer<_$AppDb, Server> {
  $ServerFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get serverType => $state.composableBuilder(
      column: $state.table.serverType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get uri => $state.composableBuilder(
      column: $state.table.uri,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pwd => $state.composableBuilder(
      column: $state.table.pwd,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get folderPath => $state.composableBuilder(
      column: $state.table.folderPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $ServerOrderingComposer extends OrderingComposer<_$AppDb, Server> {
  $ServerOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get serverType => $state.composableBuilder(
      column: $state.table.serverType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get uri => $state.composableBuilder(
      column: $state.table.uri,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get username => $state.composableBuilder(
      column: $state.table.username,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pwd => $state.composableBuilder(
      column: $state.table.pwd,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get folderPath => $state.composableBuilder(
      column: $state.table.folderPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $ServerTableManager extends RootTableManager<
    _$AppDb,
    Server,
    ServerData,
    $ServerFilterComposer,
    $ServerOrderingComposer,
    $ServerCreateCompanionBuilder,
    $ServerUpdateCompanionBuilder,
    (ServerData, BaseReferences<_$AppDb, Server, ServerData>),
    ServerData,
    PrefetchHooks Function()> {
  $ServerTableManager(_$AppDb db, Server table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $ServerFilterComposer(ComposerState(db, table)),
          orderingComposer: $ServerOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> serverType = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> uri = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> pwd = const Value.absent(),
            Value<String?> folderPath = const Value.absent(),
          }) =>
              ServerCompanion(
            id: id,
            serverType: serverType,
            title: title,
            uri: uri,
            username: username,
            pwd: pwd,
            folderPath: folderPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serverType,
            required String title,
            required String uri,
            required String username,
            required String pwd,
            Value<String?> folderPath = const Value.absent(),
          }) =>
              ServerCompanion.insert(
            id: id,
            serverType: serverType,
            title: title,
            uri: uri,
            username: username,
            pwd: pwd,
            folderPath: folderPath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $ServerProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    Server,
    ServerData,
    $ServerFilterComposer,
    $ServerOrderingComposer,
    $ServerCreateCompanionBuilder,
    $ServerUpdateCompanionBuilder,
    (ServerData, BaseReferences<_$AppDb, Server, ServerData>),
    ServerData,
    PrefetchHooks Function()>;
typedef $PlacesCreateCompanionBuilder = PlacesCompanion Function({
  Value<String?> id,
  required String name,
  required double latitude,
  required double longitude,
  Value<String?> country,
  Value<String> createdAt,
  Value<int> rowid,
});
typedef $PlacesUpdateCompanionBuilder = PlacesCompanion Function({
  Value<String?> id,
  Value<String> name,
  Value<double> latitude,
  Value<double> longitude,
  Value<String?> country,
  Value<String> createdAt,
  Value<int> rowid,
});

class $PlacesFilterComposer extends FilterComposer<_$AppDb, Places> {
  $PlacesFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get country => $state.composableBuilder(
      column: $state.table.country,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $PlacesOrderingComposer extends OrderingComposer<_$AppDb, Places> {
  $PlacesOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get country => $state.composableBuilder(
      column: $state.table.country,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $PlacesTableManager extends RootTableManager<
    _$AppDb,
    Places,
    Place,
    $PlacesFilterComposer,
    $PlacesOrderingComposer,
    $PlacesCreateCompanionBuilder,
    $PlacesUpdateCompanionBuilder,
    (Place, BaseReferences<_$AppDb, Places, Place>),
    Place,
    PrefetchHooks Function()> {
  $PlacesTableManager(_$AppDb db, Places table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $PlacesFilterComposer(ComposerState(db, table)),
          orderingComposer: $PlacesOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String?> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlacesCompanion(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            country: country,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String?> id = const Value.absent(),
            required String name,
            required double latitude,
            required double longitude,
            Value<String?> country = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlacesCompanion.insert(
            id: id,
            name: name,
            latitude: latitude,
            longitude: longitude,
            country: country,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $PlacesProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    Places,
    Place,
    $PlacesFilterComposer,
    $PlacesOrderingComposer,
    $PlacesCreateCompanionBuilder,
    $PlacesUpdateCompanionBuilder,
    (Place, BaseReferences<_$AppDb, Places, Place>),
    Place,
    PrefetchHooks Function()>;
typedef $MediaCreateCompanionBuilder = MediaCompanion Function({
  Value<int> id,
  required int serverId,
  required String eTag,
  required String mimeType,
  required String pathFile,
  required String creationDate,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> placeId,
});
typedef $MediaUpdateCompanionBuilder = MediaCompanion Function({
  Value<int> id,
  Value<int> serverId,
  Value<String> eTag,
  Value<String> mimeType,
  Value<String> pathFile,
  Value<String> creationDate,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> placeId,
});

class $MediaFilterComposer extends FilterComposer<_$AppDb, Media> {
  $MediaFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get serverId => $state.composableBuilder(
      column: $state.table.serverId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get eTag => $state.composableBuilder(
      column: $state.table.eTag,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get mimeType => $state.composableBuilder(
      column: $state.table.mimeType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get pathFile => $state.composableBuilder(
      column: $state.table.pathFile,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get creationDate => $state.composableBuilder(
      column: $state.table.creationDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get placeId => $state.composableBuilder(
      column: $state.table.placeId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $MediaOrderingComposer extends OrderingComposer<_$AppDb, Media> {
  $MediaOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get serverId => $state.composableBuilder(
      column: $state.table.serverId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get eTag => $state.composableBuilder(
      column: $state.table.eTag,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get mimeType => $state.composableBuilder(
      column: $state.table.mimeType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get pathFile => $state.composableBuilder(
      column: $state.table.pathFile,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get creationDate => $state.composableBuilder(
      column: $state.table.creationDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get placeId => $state.composableBuilder(
      column: $state.table.placeId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $MediaTableManager extends RootTableManager<
    _$AppDb,
    Media,
    MediaData,
    $MediaFilterComposer,
    $MediaOrderingComposer,
    $MediaCreateCompanionBuilder,
    $MediaUpdateCompanionBuilder,
    (MediaData, BaseReferences<_$AppDb, Media, MediaData>),
    MediaData,
    PrefetchHooks Function()> {
  $MediaTableManager(_$AppDb db, Media table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $MediaFilterComposer(ComposerState(db, table)),
          orderingComposer: $MediaOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> serverId = const Value.absent(),
            Value<String> eTag = const Value.absent(),
            Value<String> mimeType = const Value.absent(),
            Value<String> pathFile = const Value.absent(),
            Value<String> creationDate = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> placeId = const Value.absent(),
          }) =>
              MediaCompanion(
            id: id,
            serverId: serverId,
            eTag: eTag,
            mimeType: mimeType,
            pathFile: pathFile,
            creationDate: creationDate,
            latitude: latitude,
            longitude: longitude,
            placeId: placeId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int serverId,
            required String eTag,
            required String mimeType,
            required String pathFile,
            required String creationDate,
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> placeId = const Value.absent(),
          }) =>
              MediaCompanion.insert(
            id: id,
            serverId: serverId,
            eTag: eTag,
            mimeType: mimeType,
            pathFile: pathFile,
            creationDate: creationDate,
            latitude: latitude,
            longitude: longitude,
            placeId: placeId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $MediaProcessedTableManager = ProcessedTableManager<
    _$AppDb,
    Media,
    MediaData,
    $MediaFilterComposer,
    $MediaOrderingComposer,
    $MediaCreateCompanionBuilder,
    $MediaUpdateCompanionBuilder,
    (MediaData, BaseReferences<_$AppDb, Media, MediaData>),
    MediaData,
    PrefetchHooks Function()>;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $ServerTableManager get server => $ServerTableManager(_db, _db.server);
  $PlacesTableManager get places => $PlacesTableManager(_db, _db.places);
  $MediaTableManager get media => $MediaTableManager(_db, _db.media);
}
