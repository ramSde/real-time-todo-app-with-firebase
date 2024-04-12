import 'package:flutter/material.dart';
import 'package:multi_user_todo_app/controller/todoContoller.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:  DefaultFirebaseOptions.currentPlatform,
    );
 
  
  runApp(TodoScreen());
}


class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTodoDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: Provider.of<TodoProvider>(context).todoStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Todo>? todos = snapshot.data;
            return ListView.builder(
              itemCount: todos?.length ?? 0,
              itemBuilder: (context, index) {
                final todo = todos![index];
                return ListTile(
                  title: Text(todo.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditTodoDialog(context, todo),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTodoAtIndex(context, todo),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Todo"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter your todo"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () {
                Provider.of<TodoProvider>(context, listen: false).addTodo(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    TextEditingController controller = TextEditingController(text: todo.title);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Todo"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter your todo"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Update"),
              onPressed: () {
                Provider.of<TodoProvider>(context, listen: false).updateTodo(todo.id, controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTodoAtIndex(BuildContext context, Todo todo) {
    Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo.id);
  }
}

class Todo {
  final String id;
  final String title;

  Todo({
    required this.id,
    required this.title,
  });

  factory Todo.fromJson(String id, Map<String, dynamic> json) {
    return Todo(
      id: id,
      title: json['title'] ?? '',
    );
  }
}


