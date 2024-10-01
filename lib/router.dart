import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piyp/bottom_bar.dart';
import 'package:piyp/carousel.dart';
import 'package:piyp/home_page.dart';
import 'package:piyp/maps.dart';
import 'package:piyp/settings/edit_server.dart';
import 'package:piyp/settings_page.dart';
import 'package:piyp/video_page.dart';

final appRouter = GoRouter(
  routes: [
    ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(),
              child: BottomBar(uri: state.uri.toString()),
            ),
          );
        },
        routes: [
          GoRoute(
            name: 'Home',
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            name: 'Map',
            path: '/map',
            builder: (context, state) => const MapPage(),
          ),
          GoRoute(
            name: 'Settings',
            path: '/settings',
            builder: (context, state) => const NewSettingsPage(),
          ),
        ]),
    GoRoute(
        name: 'Image',
        path: '/images/:eTag',
        builder: (context, state) => Carousel(
              eTag: state.pathParameters['eTag'],
            )),
    GoRoute(
        name: 'Video',
        path: '/videos/:eTag',
        builder: (context, state) => VideoPage(
              eTag: state.pathParameters['eTag'],
            )),
    GoRoute(
        name: 'EditServer',
        path: '/settings/edit/:id',
        builder: (context, state) => EditServerPage(
              serverId: int.parse(state.pathParameters['id'] ?? '0'),
            )),
  ],
);
