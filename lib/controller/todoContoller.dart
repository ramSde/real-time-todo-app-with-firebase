import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_user_todo_app/main.dart';

class TodoProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<Todo>> _todoStream;

  TodoProvider() {
    _todoStream = _firestore.collection('todo').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Todo.fromJson(doc.id, doc.data())).toList();
    });
  }

  Stream<List<Todo>> get todoStream => _todoStream;

  void addTodo(String title) {
    _firestore.collection('todo').add({'title': title});
  }

  void updateTodo(String id, String title) {
    _firestore.collection('todo').doc(id).update({'title': title});
  }

  void deleteTodo(String id) {
    _firestore.collection('todo').doc(id).delete();
  }
}
