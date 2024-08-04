import 'package:flutter/material.dart';
import 'todo_service.dart';

class TodoProvider with ChangeNotifier {
  List<Map<String, dynamic>> _todos = [];
  final TodoService _todoService = TodoService();

  List<Map<String, dynamic>> get todos => _todos;

  Future<void> loadTodos() async {
    try {
      final todos = await _todoService.fetchTodos();
      _todos = List<Map<String, dynamic>>.from(todos);
      notifyListeners();
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  // add new ToDo
  void addTodo(String title) {
    final newTodo = {'todo': title, 'completed': false};
    _todos.add(newTodo);
    notifyListeners();
  }

  // edit ToDo
  void editTodo(int index, String newTitle) {
    _todos[index]['todo'] = newTitle;
    notifyListeners();
  }

  // delete specific ToDo
  void deleteTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  // checkbox
  void toggleTodoCompletion(int index) {
    _todos[index]['completed'] = !_todos[index]['completed'];
    notifyListeners();
  }

  // delete all checked ToDo List
  void deleteCheckedTodos() {
    _todos.removeWhere((todo) => todo['completed']);
    notifyListeners();
  }
}
