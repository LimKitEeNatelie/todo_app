import 'package:dio/dio.dart';

class TodoService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchTodos() async {
    try {
      final response =
          await _dio.get('https://dummyjson.com/todos/user/1?limit=5');
      print(response.data);
      return response.data['todos'] ?? [];
    } catch (e) {
      print('Error fetching todos: $e');
      return [];
    }
  }
}
