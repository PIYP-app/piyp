import 'package:go_router/go_router.dart';
import 'package:piyp/home_page.dart';
import 'package:piyp/photo_page.dart';
import 'package:piyp/video_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      name: 'Home',
      path: '/',
      builder: (context, state) => const HomePage(title: 'Home Page'),
    ),
    GoRoute(
        name: 'Photo',
        path: '/photos/:eTag',
        builder: (context, state) => PhotoPage(
              eTag: state.pathParameters['eTag'],
              name: state.uri.queryParameters['name']!,
            )),
    GoRoute(
        name: 'Video',
        path: '/videos/:eTag',
        builder: (context, state) => VideoPage(
              eTag: state.pathParameters['eTag'],
              name: state.uri.queryParameters['name']!,
            ))
  ],
);
