import 'package:firestore_blog/model/todo.dart';
import 'package:firestore_blog/pages/add_edit_todo_page.dart';
import 'package:firestore_blog/repository/firebase_todos_repository.dart';
import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    Key? key,
    required this.todosRepository,
    required this.todo,
  }) : super(key: key);

  final FirebaseTodosRepository todosRepository;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete),
      ),
      onDismissed: (direction) {
        todosRepository.deleteTodo(todo);
      },
      key: ValueKey(todo.id),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditTodoPage(
                  todosRepository: todosRepository,
                  isEditing: true,
                  todo: todo),
            ),
          );
        },
        trailing: Checkbox(
          value: todo.complete,
          checkColor: Colors.black,
          onChanged: (onChanged) {
            todosRepository.updateTodo(todo.copyWith(complete: onChanged));
          },
        ),
        title: Text("${todo.note}"),
        subtitle: Text("${todo.description}"),
      ),
    );
  }
}
