import 'package:firestore_blog/model/todo.dart';
import 'package:firestore_blog/pages/add_edit_todo_page.dart';
import 'package:firestore_blog/repository/firebase_todos_repository.dart';
import 'package:firestore_blog/widgets/empty_widget.dart';
import 'package:firestore_blog/widgets/note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  final FirebaseTodosRepository todosRepository = FirebaseTodosRepository();

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(t!.home)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AddEditTodoPage(todosRepository: todosRepository),
              ),
            );
          },
          icon: Icon(Icons.add),
          label: Text(t.createNote),
        ),
        body: StreamBuilder<List<Todo>>(
            stream: todosRepository.todos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final todos = snapshot.data;
                if (todos!.isEmpty) {
                  return EmptyWidget();
                } else {
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      Todo todo = todos[index];
                      return NoteItem(
                          todosRepository: todosRepository, todo: todo);
                    },
                  );
                }
              }
              if (snapshot.hasError) {
                return Column(children: <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Stack trace: ${snapshot.stackTrace}'),
                  ),
                ]);
              }
              return Center(child: const CircularProgressIndicator());
            }));
  }
}
