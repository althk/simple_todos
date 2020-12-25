import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../datastore/model.dart';
import '../todo_service.dart';
import 'todo_list_item.dart';

class TodoListWidget extends StatefulWidget {
  final List<Todo> todos;

  TodoListWidget(this.todos);

  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  List<Todo> _todos;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _todos = null;
    _todos = widget.todos;
  }

  @override
  void dispose() {
    _todos = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _todos = widget.todos;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _todos.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          Todo t = _todos.elementAt(i);
          return TodoListItem(
              todo: t, onDismissed: onDismissed, onChecked: onItemTapped);
        },
      ),
    );
  }

  void onDismissed(Todo todo) {
    final idx = _todos.indexWhere((element) => element.id == todo.id);
    setState(() {
      _todos.removeAt(idx);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text('Todo Archived'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              setState(() {
                _todos.insert(idx, todo);
              });
            },
          ),
        ))
        .closed
        .then((reason) {
      if (reason != SnackBarClosedReason.action)
        Provider.of<TodoService>(context, listen: false).archive(todo);
    });
  }

  void onItemTapped(Todo todo) {
    Provider.of<TodoService>(context, listen: false).toggleCompleted(todo);
  }
}
