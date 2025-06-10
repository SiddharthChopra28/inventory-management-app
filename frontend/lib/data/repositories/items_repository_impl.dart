import '../../domain/items_repository.dart';
import '../models/item.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ItemsRepositoryImpl implements ItemsRepository {
  final String _baseUrl = 'http://10.0.2.2:5556';

  final dio = Dio();

  @override
  Future<List<Item>> getItemsBySearchStr({String searchstr = ""}) async {
    try {
      var token = await FlutterSecureStorage().read(key: 'accessToken');

      final response = await dio.get(
        '$_baseUrl/items/get/search',
        queryParameters: {'searchString': searchstr},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print('Response data: ${response.data}');

      final data = response.data;

      List<Item> res = [];
      for (var x in data) {
        res.add(
          Item(
            id: x["id"],
            name: x["name"],
            quantity: x["quantity"],
            category: x["category"],
            price: x["price"],
            imageURL: x["imageURL"],
          ),
        );
      }
      return res;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<dynamic>> getCategories() async {
    try {
      var token = await FlutterSecureStorage().read(key: 'accessToken');


      final response = await dio.get(
        '$_baseUrl/items/get_categories',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final cats = response.data["categories"];
      print("cats:");
      print(cats);
      return cats;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<Item> getItemsByID({int? id}) async {
    try {
      var token = await FlutterSecureStorage().read(key: 'accessToken');
       

      final response = await dio.get(
        '$_baseUrl/items/get/id',
        queryParameters: {'id': id},
        options: Options(headers: {"Authorization": "Bearer $token"}),

      );
      final json = response.data;
      Item item = Item(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        category: json["category"],
        price: json["price"],
        imageURL: json["imageURL"],
      );
      return item;
    } catch (e) {
      print(e);
      return Item();
    }
  }

  @override
  Future<void> addItem({Item? item}) async {
    try {
      var token = await FlutterSecureStorage().read(key: 'accessToken');
       

      final response = await dio.post(
        '$_baseUrl/items/add',
        data: item?.getDetails(),
        options: Options(headers: {"Authorization": "Bearer $token"}),

      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> updateItem({Item? item}) async {
    try {
      var token = await FlutterSecureStorage().read(key: 'accessToken');
       

      final response = await dio.post(
        '$_baseUrl/items/update',
        data: item?.getDetails(),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<String> uploadImage({File? file}) async {
    try {
      FormData formdata = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file!.path,
          filename: file.path.split('/').last,
        ),
      });

      var token = await FlutterSecureStorage().read(key: 'accessToken');

       

      final response = await dio.post(
        '$_baseUrl/items/imageUpload',
        data: formdata,
        options: Options(headers: {"Authorization": "Bearer $token"}),

      );

      return response.data; // extract url from this response and return it

    } catch (e) {
      print(e);
      return "";
    }
  }




}
