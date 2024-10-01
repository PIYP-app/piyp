import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.uri});

  final String? uri;

  retrieveUriIndex(String? uri) {
    if (uri == '/') {
      return 0;
    }
    if (uri == '/map') {
      return 1;
    }
    if (uri == '/settings') {
      return 2;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
        currentIndex: retrieveUriIndex(uri),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          var currentIndex = retrieveUriIndex(uri);
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              context.push('/');
              break;
            case 1:
              context.push('/map');
              break;
            case 2:
              context.push('/settings');
              break;
          }
        });
  }
}
