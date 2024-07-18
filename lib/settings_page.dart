import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    retrieveSharedPreferences();
  }

  retrieveSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {
        uri = preferences.getString('webdav_uri') ?? '';
        username = preferences.getString('webdav_user') ?? '';
        password = preferences.getString('webdav_password') ?? '';
        folderPath = preferences.getString('webdav_folder_path') ?? '';
      });
    }
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
                    preferences.setString('webdav_uri', value);
                  },
                )),
            CupertinoFormRow(
                prefix: const Text('Username '),
                child: CupertinoTextField(
                  controller: TextEditingController(text: username),
                  onChanged: (value) {
                    preferences.setString('webdav_user', value);
                  },
                )),
            CupertinoFormRow(
                prefix: const Text('Password '),
                child: CupertinoTextField(
                  controller: TextEditingController(text: password),
                  onChanged: (value) {
                    preferences.setString('webdav_password', value);
                  },
                )),
            CupertinoFormRow(
                prefix: const Text('Folder path '),
                child: CupertinoTextField(
                  controller: TextEditingController(text: folderPath),
                  onChanged: (value) {
                    preferences.setString('webdav_folder_path', value);
                  },
                ))
          ],
        ));
  }
}
