import 'package:simple_todo_manager/datastore/datastore.dart';
import 'package:simple_todo_manager/datastore/model.dart';
import 'package:simple_todo_manager/todo_service.dart';
import 'package:test/test.dart';

void main() {
  TodoService _service;
  Datastore _db;

  setUp(() async {
    _db = InMemoryDb();
    _service = TodoService(_db);
  });

  tearDown(() async {
    _service.dispose();
    _service = null;
    _db = null;
  });

  test('add adds a new todo and refreshes the stream', () {
    const todoText = 'Test one todo';
    _service.add(todoText, <String>['test']);

    _service.todos.listen(expectAsync1((todos) {
      expect(todos.length, 1);
      expect(todos.elementAt(0).todo, todoText);
      expect(todos.elementAt(0).tags, <String>['test']);
      expect(todos.elementAt(0).completed, false);
      expect(todos.elementAt(0).archived, false);
    }, count: 1));
  });

  group('toggleCompleted', () {
    Todo t;

    setUp(() async {
      t = _db.addTodo('todo', []);
    });

    test('marks an uncompleted todo complete', () {
      expect(t.completed, false);
      _service.toggleCompleted(t);

      _service.todos.listen(expectAsync1((todos) {
        expect(todos.length, 1);
        expect(todos.elementAt(0).id, t.id);
        expect(todos.elementAt(0).completed, true);
        expect(todos.elementAt(0).archived, false);
      }, count: 1));
    });

    test('marks a completed todo un-complete', () {
      _db.completeTodo(t.id);
      expect(t.completed, true);
      _service.toggleCompleted(t);

      _service.todos.listen(expectAsync1((todos) {
        expect(todos.length, 1);
        expect(todos.elementAt(0).id, t.id);
        expect(todos.elementAt(0).completed, false);
        expect(todos.elementAt(0).archived, false);
      }, count: 1));
    });
  });

  test('archiveTodo archives a todo', () {
    Todo t = _db.addTodo('todo', []);
    expect(t.archived, false);

    _service.archive(t);

    List<Todo> _todos = _db.getTodos(includeArchived: true);
    expect(_todos.elementAt(0).archived, true);
    expect(_todos.elementAt(0).id, t.id);
  });
}
