import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme_switcher.dart';
import 'datastore/model.dart';
import 'todo_service.dart';
import 'widgets/add_todo.dart';
import 'widgets/misc.dart';
import 'widgets/todo_list.dart';

class TodoListPage extends StatelessWidget {
  final String title;

  TodoListPage({Key key, this.title}) : super(key: key);

  void _addTodo(BuildContext context) async {
    await showDialog(
        context: context,
        useSafeArea: true,
        barrierColor: Colors.grey.withOpacity(0.9),
        builder: (context) {
          return AddTodoWidget();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
        iconTheme: Theme.of(context).iconTheme,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/ic_launcher.png',
                fit: BoxFit.scaleDown, height: 25, width: 20),
            Container(width: 15),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<AppThemeSwitcher>(context, listen: false)
                      .isDarkModeInUse
                  ? Icons.brightness_high_sharp
                  : Icons.brightness_4,
              semanticLabel: 'Switch Theme Mode',
            ),
            onPressed: () {
              Provider.of<AppThemeSwitcher>(context, listen: false)
                  .toggleDarkMode();
            },
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 8.0),
        child: _getTodoList(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        child: FloatingActionButton.extended(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).buttonTheme.colorScheme.primary,
          onPressed: () => _addTodo(context),
          tooltip: 'Add Todo',
          icon: Icon(Icons.add),
          label: Text('ADD TODO'),
          elevation: 16.0,
        ),
      ),
    );
  }

  Widget _getTodoList(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: Provider.of<TodoService>(context, listen: false).todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        if (snapshot.hasError) {
          return DataErrorWidget(snapshot.error);
        }

        if (!snapshot.hasData) {
          return NoTodosWidget();
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            print('Connection is done, $snapshot');
            break;
        }

        if (snapshot.data.length == 0) {
          return NoTodosWidget();
        }
        return TodoListWidget(snapshot.data);
      },
    );
  }
}
