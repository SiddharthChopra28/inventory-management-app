import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/items_repository.dart';
import '../../data/repositories/items_repository_impl.dart';
import '../../data/models/item.dart';


part 'items_add_edit_event.dart';
part 'items_add_edit_state.dart';


class ItemsAddEditBloc extends Bloc<ItemsAddEditEvent, ItemsAddEditState> {

  final ItemsRepository itemRepo = ItemsRepositoryImpl();

  ItemsAddEditBloc() : super(ItemsAddEditLoadingState()) {
    on<ItemsAddEditOpenedEvent>(_onStart);
    on<SubmitFormEvent>(_onSubmit);
  }

  Future<void> _onStart(ItemsAddEditOpenedEvent event, Emitter<ItemsAddEditState> emit) async {
    // fetch the data here
    int? id = event.itemid;

    Item item = await itemRepo.getItemsByID(id: id);

    emit(ItemsAddEditLoadedState(item: item)); // pass in an Item(...) here
    //
  }

  Future <void> _onSubmit(SubmitFormEvent event, Emitter<ItemsAddEditState> emit) async{
    emit(ItemsAddEditLoadingState());

    var details = event.details;
    var file = event.file;

    String imgUrl = await itemRepo.uploadImage(file: file);

    details?["imageURL"] = imgUrl;

    if (details?["id"] == null){
      await itemRepo.addItem(item: Item(
        name: details?["name"],
        quantity: int.parse(details?["quantity"]),
        category: details?["category"],
        price: double.parse(details?["price"]),
        imageURL: details?["imageURL"]
      ));
    }
    else{
      await itemRepo.updateItem(item: Item(
          id: details?["id"],
          name: details?["name"],
          quantity: details?["quantity"],
          category: details?["category"],
          price: details?["price"],
          imageURL: details?["imageURL"]
      ));
    }

  }

}