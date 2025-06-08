import 'dart:ffi';

/// Item class.
/// Each `Item` has an `id`, `description` and `completed` boolean field.
class Item {
  final int? id;
  final String name;
  final int quantity;
  final String category;
  final Float price;
  final String imageURL;

  Item({
    this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.price,
    this.imageURL = ""
  });

  getDetails(){
    return {'id': id, 'name': name, 'quantity': quantity, 'category': category, 'price': price, 'imageURL': imageURL};
  }


  // editItem
  // deleteItem



}

// Item Widget
class ItemWidget {

}