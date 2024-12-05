import 'dart:convert';

import 'package:http/http.dart' as http;

class NewsService {
  static const String baseUrl = 'https://newsapi.org/v2';
  // TODO: use dotenv
  static const String apiKey = '8d1cf0c03e844d159b5b9cbfcd9236b4';

  Future<Map<String, dynamic>> fetchTopHeadlines() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
      );

      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
