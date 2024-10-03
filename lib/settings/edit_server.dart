import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:piyp/database/database.dart';
import 'package:piyp/init_db.dart';

class EditServerPage extends StatefulWidget {
  final int serverId;

  const EditServerPage({super.key, required this.serverId});

  @override
  _EditServerPageState createState() => _EditServerPageState();
}

class _EditServerPageState extends State<EditServerPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _urlController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _folderPathController;
  ServerData? _server;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _urlController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _folderPathController = TextEditingController();
    _loadServer();
  }

  Future<void> _loadServer() async {
    final server = await (database.select(database.server)
          ..where((t) => t.id.equals(widget.serverId)))
        .getSingle();

    setState(() {
      _server = server;
      _nameController.text = server.title;
      _urlController.text = server.uri;
      _usernameController.text = server.username;
      _passwordController.text = server.pwd;
      _folderPathController.text = server.folderPath ?? '';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _folderPathController.dispose();
    super.dispose();
  }

  Future<void> _updateServer() async {
    if (_formKey.currentState!.validate() && _server != null) {
      database.server.insertOnConflictUpdate(
        ServerCompanion(
          id: drift.Value(_server!.id),
          title: drift.Value(_nameController.text),
          serverType: drift.Value(_server!.serverType),
          uri: drift.Value(_urlController.text),
          username: drift.Value(_usernameController.text),
          pwd: drift.Value(_passwordController.text),
          folderPath: drift.Value(_folderPathController.text),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Server'),
      ),
      body: _server == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Server Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a server name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _urlController,
                      decoration:
                          const InputDecoration(labelText: 'Server URL'),
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
                      decoration:
                          const InputDecoration(labelText: 'Folder Path'),
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton.filled(
                      onPressed: _updateServer,
                      child: const Text('Update Server'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
