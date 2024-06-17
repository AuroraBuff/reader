import 'package:go_router/go_router.dart';
import 'package:reader/pages/Home.dart';
import 'package:reader/pages/reader.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
        name: 'HomePage',
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            name: 'ReaderPage',
            path: 'reader',
            builder: (context, state) => const ReaderPage(),
          ),
        ]),
  ],
);
