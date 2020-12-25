import 'package:flutter/material.dart';

class NoTodosWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'There are no todos! Please add some.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class DataErrorWidget extends StatelessWidget {
  final String error;
  DataErrorWidget(this.error);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                Text('$error'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
