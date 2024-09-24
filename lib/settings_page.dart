import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/enum.dart';
import 'package:piyp/init_db.dart';
import 'package:piyp/sources.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController titleInputController = TextEditingController();
  final TextEditingController uriInputController = TextEditingController();
  final TextEditingController usernameInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  final TextEditingController folderPathInputController =
      TextEditingController();
  List<ServerData> servers = [];
  Sources sources = Sources();

  @override
  void initState() {
    super.initState();
    retrieveServerFromDb();
  }

  retrieveServerFromDb() async {
    List<ServerData> retrieveServers =
        await database.select(database.server).get();

    if (!mounted || retrieveServers.isEmpty) {
      return;
    }

    setState(() {
      servers = retrieveServers;
    });
  }

  // updateSettingsInDb() async {
  //   await database.server.insertOne(
  //       ServerCompanion(
  //         id: Value(servers[0].id),
  //         title: Value(titleInputController.text),
  //         serverType: Value(ServerType.webdav.value),
  //         uri: Value(uriInputController.text),
  //         username: Value(usernameInputController.text),
  //         pwd: Value(passwordInputController.text),
  //         folderPath: Value(folderPathInputController.text),
  //       ),
  //       mode: InsertMode.insertOrReplace);

  //   List<ServerData> ttt = await database.select(database.server).get();

  //   print(ttt);
  // }

  addNewServer() async {
    await database.server.insertOne(
        ServerCompanion(
          title: Value(titleInputController.text),
          serverType: Value(ServerType.webdav.value),
          uri: Value(uriInputController.text),
          username: Value(usernameInputController.text),
          pwd: Value(passwordInputController.text),
          folderPath: Value(folderPathInputController.text),
        ),
        mode: InsertMode.insertOrReplace);

    List<ServerData> retrieveServers =
        await database.select(database.server).get();

    setState(() {
      servers = retrieveServers;
      titleInputController.text = '';
      usernameInputController.text = '';
      passwordInputController.text = '';
      folderPathInputController.text = '';
    });
  }

  removeServerFromDb(ServerData server) async {
    await database.server.deleteOne(server);

    setState(() {
      servers.remove(server);
    });

    List<ServerData> ttt = await database.select(database.server).get();

    print(ttt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: ListView(children: [
          servers.isNotEmpty
              ? CupertinoFormSection(
                  header: const Text('WebDAV servers'),
                  children: servers
                      .map((server) => Dismissible(
                          key: Key(server.hashCode.toString()),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            removeServerFromDb(server);
                          },
                          child: CupertinoListTile(
                            title: Text(server.title),
                            // leading: const Icon(Icons.warning),
                          )))
                      .toList(),
                )
              : const SizedBox(),
          CupertinoFormSection(
            header: const Text('Add a webDAV server'),
            children: [
              CupertinoTextFormFieldRow(
                prefix: const Text('Title'),
                controller: titleInputController,
              ),
              CupertinoTextFormFieldRow(
                prefix: const Text('URL'),
                controller: uriInputController,
              ),
              CupertinoTextFormFieldRow(
                  controller: usernameInputController,
                  prefix: const Text('Username')),
              CupertinoTextFormFieldRow(
                  prefix: const Text('Password'),
                  controller: passwordInputController),
              CupertinoTextFormFieldRow(
                prefix: const Text('Folder path'),
                controller: folderPathInputController,
              ),
              CupertinoButton.filled(
                  onPressed: addNewServer, child: const Text('Submit'))
            ],
          )
        ]));
  }
}
