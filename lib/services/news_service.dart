import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:news_app/models/news.dart';
import 'package:news_app/utils/const.dart';

class NewsService {
  static Future<List<News>> getNews(String query) async {
    var url = 'https://newsapi.org/v2/everything?q=audi&apiKey=$apiKey';
    var response = await Dio().get(url);
    if (response.statusCode == 200) {
      final List news = response.data['articles'];

      return news.map((json) => News.fromJson(json)).where((news) {
        final titleLower = news.title.toLowerCase();
        final sourceLower = news.source!.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            sourceLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
