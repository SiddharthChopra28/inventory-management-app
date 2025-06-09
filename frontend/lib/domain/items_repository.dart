import '../data/models/item.dart';
import 'dart:io';

abstract class ItemsRepository{
  Future<List<Item>> getItemsBySearchStr({String searchstr=""});
  Future<List<String>> getCategories();
  Future<Item> getItemsByID({int ?id});
  Future<void> addItem({Item item});
  Future<void> updateItem({Item item});
  Future<String> uploadImage({File? file});
}