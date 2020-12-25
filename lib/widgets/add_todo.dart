import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../todo_service.dart';

class AddTodoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _textCtrl = TextEditingController();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textCtrl,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Enter Todo',
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton.icon(
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  icon: Icon(Icons.save),
                  label: Text(
                    'ADD',
                    //style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    Provider.of<TodoService>(context, listen: false)
                        .add(_textCtrl.text, <String>['test']);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
