import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/item.dart';
import 'package:frontend/domain/items_repository.dart';
import '../../data/repositories/items_repository_impl.dart';

part 'items_grid_event.dart';
part 'items_grid_state.dart';


class ItemsGridBloc extends Bloc<ItemsGridEvent, ItemsGridState> {
  final ItemsRepository itemRepo = ItemsRepositoryImpl();

  ItemsGridBloc() : super(ItemsGridLoadingState()) {
    on<ItemsGridStartedEvent>(_onStart);
    on<ChangeSearchStringEvent>(_onSearch);
}

  Future<void> _onStart(ItemsGridStartedEvent event, Emitter<ItemsGridState> emit) async {
    // fetch the data here
    var items = await itemRepo.getItemsBySearchStr(searchstr: "");
    var cats = await itemRepo.getCategories();

    emit(ItemsGridLoadedState(items: items, categories: cats));
  }

  Future <void> _onSearch(ChangeSearchStringEvent event, Emitter<ItemsGridState> emit) async{
    emit(ItemsGridLoadingState());

    var items = await itemRepo.getItemsBySearchStr(searchstr: event.currSearchStr);
    var cats = await itemRepo.getCategories();

    emit(ItemsGridLoadedState(items: items, categories: cats));
  }
}