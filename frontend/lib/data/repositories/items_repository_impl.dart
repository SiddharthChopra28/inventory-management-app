import '../../domain/items_repository.dart';
import '../models/item.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';



class ItemsRepositoryImpl implements ItemsRepository {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final dio = Dio();

  @override
  Future<List<Item>> getItemsBySearchStr({String searchstr = ""}) async {
    try{
      final response = await dio.get(
        '$_baseUrl/items/get/search',
        queryParameters: {'searchString': searchstr},
      );
      print('Response data: ${response.data}');

      final data = response.data;
      List<Item> res = [];
      for (var x in data){
        res.add(Item(
          id: x["id"],
          name: x["name"],
          quantity: x["quantity"],
          category: x["category"],
          price: x["price"],
          imageURL: x["imageURL"]
        ));
      }
      return res;
    }
    catch(e){
      print(e);
      return [];
    }
    

  }

  @override
  Future<List<String>> getCategories() async {
    try{
      final response = await dio.get(
        '$_baseUrl/items/get_categories',
      );
      print('Response data: ${response.data}');

    }
    catch(e){
      print(e);
    }

  }

  @override
  Future<Item> getItemsByID({int? id}) async{
    try{
      final response = await dio.get(
        '$_baseUrl/items/get/id',
        queryParameters: {'id': id},
      );
      print('Response data: ${response.data}');

    }
    catch(e){
      print(e);
    }

    // return an item from here

  }

  @override
  Future<void> addItem({Item ?item}) async{
    try{
      final response = await dio.post(
          '$_baseUrl/items/add',
          data: item?.getDetails()
      );
    }
    catch(e){
      print(e);
    }
  }

  @override
  Future<void> updateItem({Item ?item}) async{
    try{
      final response = await dio.post(
          '$_baseUrl/items/update',
          data: item?.getDetails()
      );
    }
    catch(e){
      print(e);
    }
  }

  @override
  Future<String> uploadImage({File? file}) async{
    try{
      FormData formdata = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file!.path,
          filename: file.path.split('/').last,
        )

      });

      final response = await dio.post(
          '$_baseUrl/items/imageUpload',
          data: formdata
      );
      print(response.data); // extract url from this response and return it
    }
    catch(e){
      print(e);
    }
  }

}
