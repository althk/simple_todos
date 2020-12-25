import 'dart:async';

import 'datastore/datastore.dart';
import 'datastore/model.dart';

class TodoService {
  Datastore _db;
  List<String> _tagsFilter;
  bool _includeCompleted;
  bool _includeArchived;
  // ignore: close_sinks
  StreamController<List<Todo>> _ctrl = StreamController.broadcast();
  TodoService(this._db) {
    _tagsFilter = [];
    _includeArchived = false;
    _includeCompleted = true;
    _ctrl.onListen = () {
      _db.sink = _ctrl.sink;
      _refreshStream();
    };
  }

  set includeArchived(bool val) {
    _includeArchived = val;
    _refreshStream();
  }

  set includeCompleted(bool val) {
    _includeCompleted = val;
    _refreshStream();
  }

  set tagFilters(List<String> tags) {
    _tagsFilter = tags;
    _refreshStream();
  }

  void _refreshStream() {
    _db.getTodos(
        anyTagsFilter: _tagsFilter,
        includeCompleted: _includeCompleted,
        includeArchived: _includeArchived);
  }

  Stream<List<Todo>> get todos => _ctrl.stream;

  void add(String todo, List<String> tags) {
    _db.addTodo(todo, tags);
    _refreshStream();
  }

  void toggleCompleted(Todo todo) {
    if (!todo.completed) {
      _db.completeTodo(todo.id);
    } else {
      _db.unCompleteTodo(todo.id);
    }
    _refreshStream();
  }

  void archive(Todo todo) {
    _db.archiveTodo(todo.id);
    //_refreshStream();
  }

  void update(Todo todo) {
    _db.updateTodo(todo);
    _refreshStream();
  }
}
