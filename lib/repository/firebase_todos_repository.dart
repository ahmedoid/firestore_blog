import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_blog/model/todo.dart';
import 'package:firestore_blog/repository/todos_repository.dart';

class FirebaseTodosRepository implements TodosRepository {
  final todoCollection = FirebaseFirestore.instance.collection('todos');

  @override
  Future<void> addNewTodo(Todo todo) {
    return todoCollection.doc(todo.id).set(todo.toMap());
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    return todoCollection.doc(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Todo.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<void> updateTodo(Todo update) {
    return todoCollection.doc(update.id).update(update.toMap());
  }
}
