import 'package:go_router/go_router.dart';
import 'package:piyp/carousel.dart';
import 'package:piyp/home_page.dart';
import 'package:piyp/video_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      name: 'Home',
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
        name: 'Photo',
        path: '/photos/:eTag',
        builder: (context, state) => Carousel(
              eTag: state.pathParameters['eTag'],
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
