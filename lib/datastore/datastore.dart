import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import 'model.dart';

abstract class Datastore {
  List<Todo> getTodos(
      {List<String> anyTagsFilter,
      bool includeCompleted,
      bool includeArchived});
  Todo addTodo(String todo, List<String> tags);
  bool updateTodo(Todo update);
  bool archiveTodo(String id);
  bool completeTodo(String id);
  bool unCompleteTodo(String id);
  set sink(StreamSink<List<Todo>> sink);
}

class InMemoryDb implements Datastore {
  List<Todo> _todos;
  StreamSink<List<Todo>> _sink;

  InMemoryDb() : _todos = [];
  var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

  @override
  Todo addTodo(String todo, List<String> tags) {
    Todo t = Todo()
      ..id = uuid.v4()
      ..todo = todo
      ..tags = tags ?? <String>[]
      ..createdAt = DateTime.now();
    _todos.add(t);
    return t;
  }

  @override
  List<Todo> getTodos(
      {List<String> anyTagsFilter,
      bool includeCompleted = false,
      bool includeArchived = false}) {
    anyTagsFilter = anyTagsFilter ?? [];
    var res = _todos
        .where((t) =>
            t.tags.length == 0 ||
            t.tags.any((tag) =>
                anyTagsFilter.length == 0 || anyTagsFilter.contains(tag)))
        .where((t) => includeCompleted ? true : !t.completed)
        .where((t) => includeArchived ? true : !t.archived)
        .toList();
    res.sort((a, b) => a.completed ? 1 : 0);
    _sink.add(res);
    return res;
  }

  @override
  bool updateTodo(Todo update) {
    final idx = _todos.indexWhere((Todo t) => t.id == update.id);
    if (idx == -1) return false;
    _todos.elementAt(idx)
      ..tags = update.tags
      ..todo = update.todo;
    return true;
  }

  @override
  bool archiveTodo(String id) {
    final idx = _todos.indexWhere((Todo t) => t.id == id);
    if (idx == -1) return false;
    _todos.elementAt(idx)..archived = true;
    return true;
  }

  @override
  bool completeTodo(String id) {
    final idx = _todos.indexWhere((Todo t) => t.id == id);
    if (idx == -1) return false;
    _todos.elementAt(idx)
      ..completed = true
      ..completedAt = DateTime.now();
    return true;
  }

  @override
  bool unCompleteTodo(String id) {
    final idx = _todos.indexWhere((Todo t) => t.id == id);
    if (idx == -1) return false;
    _todos.elementAt(idx)
      ..completed = false
      ..completedAt = null;
    return true;
  }

  @override
  set sink(StreamSink<List<Todo>> sink) {
    _sink = sink;
  }
}
