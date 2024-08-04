import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/todo_provider.dart';

class AddEditTodoScreen extends StatelessWidget {
  final int? index;
  final String? initialTitle;

  AddEditTodoScreen({this.index, this.initialTitle});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller =
        TextEditingController(text: initialTitle);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          initialTitle == null ? 'Add New To-Do' : 'Edit To-Do',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'To-Do'),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                onPressed: () {
                  final title = _controller.text;
                  if (index == null) {
                    Provider.of<TodoProvider>(context, listen: false)
                        .addTodo(title);
                  } else {
                    Provider.of<TodoProvider>(context, listen: false)
                        .editTodo(index!, title);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green),
                child: Text(initialTitle == null ? 'Add' : 'Save'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                ),
                child: const Text('Cancel'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
