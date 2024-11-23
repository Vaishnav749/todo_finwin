import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/addpageprovider.dart';
import 'screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData.dark(),
      home: TaskListPage(),
    );
  }
}
