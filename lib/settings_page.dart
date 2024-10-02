import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:drift/drift.dart' as drift;
import 'package:piyp/database/database.dart';
import 'package:piyp/enum.dart';
import 'package:piyp/init_db.dart';
import 'package:go_router/go_router.dart';

class NewSettingsPage extends StatefulWidget {
  const NewSettingsPage({super.key});

  @override
  _NewSettingsPageState createState() => _NewSettingsPageState();
}

class _NewSettingsPageState extends State<NewSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _folderPathController = TextEditingController();
  List<ServerData> servers = [];

  @override
  void initState() {
    super.initState();
    _loadServers();
  }

  void _loadServers() async {
    final loadedServers = await database.select(database.server).get();
    if (mounted) {
      setState(() {
        servers = loadedServers;
      });
    }
  }

  Future<void> _addServer() async {
    if (_formKey.currentState!.validate()) {
      await database.server.insertOne(
        ServerCompanion(
          title: drift.Value(_nameController.text),
          serverType: drift.Value(ServerType.webdav.value),
          uri: drift.Value(_urlController.text),
          username: drift.Value(_usernameController.text),
          pwd: drift.Value(_passwordController.text),
          folderPath: drift.Value(_folderPathController.text),
        ),
        mode: drift.InsertMode.insertOrReplace,
      );
      _loadServers();
      _clearForm();
    }
  }

  void _clearForm() {
    _nameController.clear();
    _urlController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _folderPathController.clear();
  }

  Future<void> _removeServer(ServerData server) async {
    await database.server.deleteOne(server);
    _loadServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebDAV Server Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Server Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a server name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(labelText: 'Server URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a server URL';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _folderPathController,
                  decoration: const InputDecoration(labelText: 'Folder Path'),
                ),
                const SizedBox(height: 16),
                CupertinoButton.filled(
                  onPressed: _addServer,
                  child: const Text('Add Server'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Saved Servers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final server = servers[index];

              return Dismissible(
                key: Key(server.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _removeServer(server);
                },
                child: ListTile(
                  title: Text(server.title),
                  subtitle: Text(server.uri),
                  onLongPress: () {
                    context.push('/indexation');
                  },
                  onTap: () {
                    context
                        .push('/settings/edit/${server.id}')
                        .then((_) => mounted ? _loadServers() : null);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
