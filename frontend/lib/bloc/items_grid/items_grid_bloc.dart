import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/item.dart';

part 'items_grid_event.dart';
part 'items_grid_state.dart';


class ItemsGridBloc extends Bloc<ItemsGridEvent, ItemsGridState> {

  ItemsGridBloc() : super(ItemsGridLoadingState()) {
    on<ItemsGridStartedEvent>(_onStart);
    on<ChangeSearchStringEvent>(_onSearch);
}

  Future<void> _onStart(ItemsGridStartedEvent event, Emitter<ItemsGridState> emit) async {
    // fetch the data here
    emit(const ItemsGridLoadedState(items: [], categories: []));
  }

  _onSearch(ChangeSearchStringEvent event, Emitter<ItemsGridState> emit){
    emit(ItemsGridLoadingState());
    // fetch the data again
    emit(const ItemsGridLoadedState(items: [], categories: []));
  }
}