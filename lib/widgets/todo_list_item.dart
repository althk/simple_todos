import 'package:flutter/material.dart';

import '../datastore/model.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onDismissed;
  final Function onChecked;

  TodoListItem(
      {@required this.todo,
      @required this.onDismissed,
      @required this.onChecked});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background:
          Container(color: Theme.of(context).backgroundColor.withAlpha(100)),
      onDismissed: (direction) {
        onDismissed(todo);
      },
      child: Card(
        elevation: 3.0,
        child: ListTile(
          leading: GestureDetector(
            child: todo.completed
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).accentColor,
                  )
                : Icon(
                    Icons.circle,
                    color: Theme.of(context).backgroundColor,
                  ),
            onTap: () {
              onChecked(todo);
            },
          ),
          onTap: () {},
          title: Text(
            todo.todo,
            style: todo.completed
                ? TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .color
                        .withAlpha(150))
                : Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18),
          ),
          isThreeLine: false,
        ),
      ),
    );
  }
}
