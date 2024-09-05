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
  String uri = '';
  String username = '';
  String password = '';
  String folderPath = '';

  @override
  void initState() {
    super.initState();
    retrieveSharedPreferences();
  }

  retrieveSharedPreferences() async {
    List<ServerData> servers = await database.select(database.server).get();

    if (!mounted) {
      return;
    }

    setState(() {
      uri = servers[0].uri;
      username = servers[0].username;
      password = servers[0].pwd;
      folderPath = servers[0].folderPath ?? '';
    });
  }

  updateSettingsInDb() async {
    await database.into(database.server).insert(ServerCompanion.insert(
          title: 'kdrive',
          uri: uri,
          username: username,
          pwd: password,
          folderPath: Value(folderPath),
        ));

    final List<ServerData> allItems =
        await database.select(database.server).get();

    print(allItems);
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: TextEditingController(text: uri),
                  onChanged: (value) {
                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      uri = value;
                    });
                  },
                )),
            CupertinoFormRow(
                prefix: const Text('Username '),
                child: CupertinoTextField(
                  controller: TextEditingController(text: username),
                  onChanged: (value) {
                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      username = value;
                    });
                  },
                )),
            CupertinoFormRow(
                prefix: const Text('Password '),
                child: CupertinoTextField(
                  controller: TextEditingController(text: password),
                  onChanged: (value) {
                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      password = value;
                    });
                  },
                )),
            CupertinoFormRow(
                prefix: const Text('Folder path '),
                child: CupertinoTextField(
                  controller: TextEditingController(text: folderPath),
                  onChanged: (value) {
                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      folderPath = value;
                    });
                  },
                )),
            CupertinoButton.filled(
                onPressed: updateSettingsInDb, child: const Text('Submit'))
          ],
        ));
  }
}
