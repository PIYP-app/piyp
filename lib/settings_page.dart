import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piyp/database/database.dart';
import 'package:piyp/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController uriInputController = TextEditingController();
  final TextEditingController usernameInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  final TextEditingController folderPathInputController =
      TextEditingController();
  List<ServerData> servers = [];

  @override
  void initState() {
    super.initState();
    retrieveServerFromDb();
  }

  retrieveServerFromDb() async {
    List<ServerData> retrieveServers =
        await database.select(database.server).get();

    if (!mounted) {
      return;
    }

    setState(() {
      servers = retrieveServers;
      uriInputController.text = servers[0].uri;
      usernameInputController.text = servers[0].username;
      passwordInputController.text = servers[0].pwd;
      folderPathInputController.text = servers[0].folderPath ?? '';
    });
  }

  updateSettingsInDb() async {
    await database.server.deleteAll();
    await database.server.insertOne(
        ServerCompanion(
          title: const Value('kdrive'),
          uri: Value(uriInputController.text),
          username: Value(usernameInputController.text),
          pwd: Value(passwordInputController.text),
          folderPath: Value(folderPathInputController.text),
        ),
        mode: InsertMode.insertOrReplace);

    final List<ServerData> allItems =
        await database.select(database.server).get();

    print(allItems);
  }

  @override
  Widget build(BuildContext context) {
    if (servers.isEmpty) {
      return const SizedBox();
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
        ),
        body: CupertinoFormSection(
          header: const Text('Webdav server'),
          children: [
            CupertinoFormRow(
                prefix: const Text('URL '),
                child: CupertinoTextField(
                  controller: uriInputController,
                )),
            CupertinoFormRow(
                prefix: const Text('Username '),
                child: CupertinoTextField(
                  controller: usernameInputController,
                )),
            CupertinoFormRow(
                prefix: const Text('Password '),
                child: CupertinoTextField(
                  controller: passwordInputController,
                )),
            CupertinoFormRow(
                prefix: const Text('Folder path '),
                child: CupertinoTextField(
                  controller: folderPathInputController,
                )),
            CupertinoButton.filled(
                onPressed: updateSettingsInDb, child: const Text('Submit'))
          ],
        ));
  }
}
