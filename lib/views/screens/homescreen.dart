import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/views/shared/todo_provider.dart';
import 'package:todo_app/views/screens/todo_add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _loadTodosFuture;

  @override
  void initState() {
    super.initState();
    _loadTodosFuture =
        Provider.of<TodoProvider>(context, listen: false).loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 1.0),
            child: Text(
              'To-Do List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                Provider.of<TodoProvider>(context, listen: false)
                    .deleteCheckedTodos();
              },
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _loadTodosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  return Column(children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total: ${todoProvider.todos.length} Todos',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: todoProvider.todos.length,
                      itemBuilder: (context, index) {
                        final todo = todoProvider.todos[index];
                        final title = todo['todo'] ?? 'Untitled';
                        return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(title),
                              trailing: Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                      value: todo['completed'],
                                      onChanged: (bool? value) {
                                        todoProvider
                                            .toggleTodoCompletion(index);
                                      },
                                      shape: const CircleBorder())),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditTodoScreen(
                                      index: index,
                                      initialTitle: title,
                                    ),
                                  ),
                                );
                              },
                              //delete specific Todo
                              onLongPress: () {
                                todoProvider.deleteTodo(index);
                              },
                            ));
                      },
                    ))
                  ]);
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditTodoScreen(),
              ),
            );
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ));
  }
}
