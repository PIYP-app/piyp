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
      $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT');
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
      [id, title, uri, username, pwd, folderPath];
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
  final String title;
  final String uri;
  final String username;
  final String pwd;
  final String? folderPath;
  const ServerData(
      {required this.id,
      required this.title,
      required this.uri,
      required this.username,
      required this.pwd,
      this.folderPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
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
      'title': serializer.toJson<String>(title),
      'uri': serializer.toJson<String>(uri),
      'username': serializer.toJson<String>(username),
      'pwd': serializer.toJson<String>(pwd),
      'folder_path': serializer.toJson<String?>(folderPath),
    };
  }

  ServerData copyWith(
          {int? id,
          String? title,
          String? uri,
          String? username,
          String? pwd,
          Value<String?> folderPath = const Value.absent()}) =>
      ServerData(
        id: id ?? this.id,
        title: title ?? this.title,
        uri: uri ?? this.uri,
        username: username ?? this.username,
        pwd: pwd ?? this.pwd,
        folderPath: folderPath.present ? folderPath.value : this.folderPath,
      );
  ServerData copyWithCompanion(ServerCompanion data) {
    return ServerData(
      id: data.id.present ? data.id.value : this.id,
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
          ..write('title: $title, ')
          ..write('uri: $uri, ')
          ..write('username: $username, ')
          ..write('pwd: $pwd, ')
          ..write('folderPath: $folderPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, uri, username, pwd, folderPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerData &&
          other.id == this.id &&
          other.title == this.title &&
          other.uri == this.uri &&
          other.username == this.username &&
          other.pwd == this.pwd &&
          other.folderPath == this.folderPath);
}

class ServerCompanion extends UpdateCompanion<ServerData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> uri;
  final Value<String> username;
  final Value<String> pwd;
  final Value<String?> folderPath;
  const ServerCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.uri = const Value.absent(),
    this.username = const Value.absent(),
    this.pwd = const Value.absent(),
    this.folderPath = const Value.absent(),
  });
  ServerCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String uri,
    required String username,
    required String pwd,
    this.folderPath = const Value.absent(),
  })  : title = Value(title),
        uri = Value(uri),
        username = Value(username),
        pwd = Value(pwd);
  static Insertable<ServerData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? uri,
    Expression<String>? username,
    Expression<String>? pwd,
    Expression<String>? folderPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (uri != null) 'uri': uri,
      if (username != null) 'username': username,
      if (pwd != null) 'pwd': pwd,
      if (folderPath != null) 'folder_path': folderPath,
    });
  }

  ServerCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? uri,
      Value<String>? username,
      Value<String>? pwd,
      Value<String?>? folderPath}) {
    return ServerCompanion(
      id: id ?? this.id,
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
          ..write('title: $title, ')
          ..write('uri: $uri, ')
          ..write('username: $username, ')
          ..write('pwd: $pwd, ')
          ..write('folderPath: $folderPath')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final Server server = Server(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [server];
}

typedef $ServerCreateCompanionBuilder = ServerCompanion Function({
  Value<int> id,
  required String title,
  required String uri,
  required String username,
  required String pwd,
  Value<String?> folderPath,
});
typedef $ServerUpdateCompanionBuilder = ServerCompanion Function({
  Value<int> id,
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
            Value<String> title = const Value.absent(),
            Value<String> uri = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> pwd = const Value.absent(),
            Value<String?> folderPath = const Value.absent(),
          }) =>
              ServerCompanion(
            id: id,
            title: title,
            uri: uri,
            username: username,
            pwd: pwd,
            folderPath: folderPath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String uri,
            required String username,
            required String pwd,
            Value<String?> folderPath = const Value.absent(),
          }) =>
              ServerCompanion.insert(
            id: id,
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

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $ServerTableManager get server => $ServerTableManager(_db, _db.server);
}
