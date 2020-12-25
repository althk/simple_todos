import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo_manager/app_theme_switcher.dart';
import 'package:simple_todo_manager/datastore/datastore.dart';
import 'package:simple_todo_manager/todo_list_page.dart';
import 'package:simple_todo_manager/todo_service.dart';

Widget createTodoListPage() => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppThemeSwitcher(),
        ),
        Provider(create: (_) => TodoService(InMemoryDb())),
      ],
      child: MaterialApp(
        home: TodoListPage(
          title: 'Test Todos',
        ),
      ),
    );

void main() {
  group('initial screen tests', () {
    testWidgets('Test initial message with no todos',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTodoListPage());
      expect(find.textContaining('There are no todos'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('finds add todo fab', (WidgetTester tester) async {
      await tester.pumpWidget(createTodoListPage());
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('performing actions', () {
    Future<void> addTodo(tester, text) async {
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.enterText(find.byType(TextField), text);
      await tester.tap(find.text('ADD'));
      await tester.pumpAndSettle();
    }

    testWidgets('adding new todos shows a list view',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTodoListPage());
      await addTodo(tester, 'test todo 1');
      await addTodo(tester, 'test todo 2');

      expect(find.byType(ListView), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'test todo 1'), findsOneWidget);
      expect(find.widgetWithText(ListTile, 'test todo 2'), findsOneWidget);
    });

    testWidgets('dismissing todos removes them from list view',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTodoListPage());
      await addTodo(tester, 'test todo 1');
      await addTodo(tester, 'test todo 2');

      await tester.drag(
          find.widgetWithText(ListTile, 'test todo 1'), Offset(500.0, 0));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'test todo 1'), findsNothing);
      expect(find.widgetWithText(ListTile, 'test todo 2'), findsOneWidget);
    });

    testWidgets('dismissing all todos removes list view also',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTodoListPage());
      await addTodo(tester, 'test todo 1');
      await addTodo(tester, 'test todo 2');

      await tester.drag(
          find.widgetWithText(ListTile, 'test todo 1'), Offset(500.0, 0));
      await tester.drag(
          find.widgetWithText(ListTile, 'test todo 2'), Offset(500.0, 0));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'test todo 1'), findsNothing);
      expect(find.widgetWithText(ListTile, 'test todo 2'), findsNothing);

      // Dismiss the snack bars to ensure the datastore calls are made.
      await tester.drag(find.byType(SnackBar), Offset(0, 50.0));
      await tester.drag(find.byType(SnackBar), Offset(0, 50.0));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsNothing);
      expect(find.textContaining('There are no todos'), findsOneWidget);
    });

    testWidgets('clicking undo in the snack bar re-adds the todo item',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTodoListPage());
      await addTodo(tester, 'test todo 1');

      await tester.drag(
          find.widgetWithText(ListTile, 'test todo 1'), Offset(500.0, 0));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'test todo 1'), findsNothing);

      await tester.tap(find.text('UNDO'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'test todo 1'), findsOneWidget);
    });
  });
}
