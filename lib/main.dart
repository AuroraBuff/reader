import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reader/router.dart';

void main() async {
  // 确保 Flutter 环境初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 GetStorage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
