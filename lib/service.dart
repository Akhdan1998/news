import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/apireturn.dart';
import 'package:news/model.dart';

class NewsServices {
  static Future<ApiReturnNews<List<News>>?> getNews() async {
    String baseUrl =
        'https://newsapi.org/v2/everything?q=apple&from=2024-02-26&to=2024-02-26&sortBy=popularity&apiKey=1b01c8e9ec3249f992946815df9de69f';
    String url = baseUrl;
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode != 200) {
      return ApiReturnNews(message: 'Please try Again');
    }
    var data = jsonDecode(response.body);
    List<News> value =
        (data['articles'] as Iterable).map((e) => News.fromJson(e)).toList();
    return ApiReturnNews(value: value);
  }
}
