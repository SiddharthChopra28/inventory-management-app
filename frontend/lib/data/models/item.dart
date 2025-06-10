import 'dart:ffi';

/// Item class.
/// Each `Item` has an `id`, `description` and `completed` boolean field.
class Item {
  final int? id;
  final String name;
  final int quantity;
  final String category;
  final double price;
  final String imageURL;

  Item({
    this.id,
     this.name="",
     this.quantity=0,
     this.category="",
     this.price=0.0,
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