import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/post.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<User>> fetchUsers() async {
    final uri = Uri.parse('$baseUrl/users');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users (${res.statusCode})');
    }
  }

  static Future<User> fetchUser(int id) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(res.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user ($id) (${res.statusCode})');
    }
  }

  static Future<List<Post>> fetchPostsByUser(int userId) async {
    final uri = Uri.parse('$baseUrl/posts?userId=$userId');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts for user $userId (${res.statusCode})');
    }
  }
}
