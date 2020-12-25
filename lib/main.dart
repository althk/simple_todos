import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'app_theme_switcher.dart';
import 'datastore/datastore.dart';
import 'todo_list_page.dart';
import 'todo_service.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AppThemeSwitcher(),
      ),
      Provider(create: (_) => TodoService(InMemoryDb())),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIMPLE TODOS',
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
        accentColor: Colors.yellow,
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme:
            GoogleFonts.ralewayTextTheme(Theme.of(context).primaryTextTheme),
      ),
      themeMode: Provider.of<AppThemeSwitcher>(context).currentTheme,
      home: TodoListPage(title: 'SIMPLE TODOS'),
      debugShowCheckedModeBanner: false,
    );
  }
}
