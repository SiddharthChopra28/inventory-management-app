part of 'items_grid_bloc.dart';

abstract class ItemsGridState extends Equatable {
  const ItemsGridState();
}

class ItemsGridLoadingState extends ItemsGridState {
  @override
  List<Object> get props => [];
}

class ItemsGridLoadedState extends ItemsGridState {
  final List<Item> items;
  const ItemsGridLoadedState({this.items = const []});
  @override
  List<Object> get props => [items];
}

class ItemsGridErrorState extends ItemsGridState {
  final String message;
  const ItemsGridErrorState({this.message = "Some error occurred"});
  @override
  List<Object> get props => [message];
}