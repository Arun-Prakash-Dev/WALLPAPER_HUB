import 'dart:convert';
import 'package:wallpaper_hub/models/photos_model.dart';
import 'package:http/http.dart' as http;

class Data {
  String apiUrl =
      "https://pixabay.com/api/?key=16898793-44ebd23130685479f755724b3&";

  Future<ImageModel> getImages(int count) async {
    final response = await http.get(Uri.parse(
        "${apiUrl}editors_choice=true&order=latest&per_page=$count&orientation=vertical"));
    if (response.statusCode == 200) {
      return ImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get images');
    }
  }

  Future<ImageModel> getSearchedImages(String query, int page) async {
    final response = await http.get(Uri.parse('${apiUrl}q=$query&page=$page'));
    if (response.statusCode == 200) {
      return ImageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get images');
    }
  }
}
