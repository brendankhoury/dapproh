import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class CacheBox {
  static Box cacheBox = Hive.box("cache");

  static Future<String> get(String url) async {
    if (cacheBox.containsKey(url)) {
      return cacheBox.get(url);
    }
    final Response response = await Dio().get(url);
    cacheBox.put(url, response.data);
    return response.data;
  }
}
