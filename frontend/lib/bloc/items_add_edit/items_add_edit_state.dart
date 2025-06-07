part of 'items_add_edit_bloc.dart';

abstract class ItemsAddEditState extends Equatable {
  const ItemsAddEditState();
}

class ItemsAddEditLoadingState extends ItemsAddEditState {
  @override
  List<Object> get props => [];
}

class ItemsAddEditLoadedState extends ItemsAddEditState {

  final Item? item;
  const ItemsAddEditLoadedState({this.item});

  @override
  List<Object> get props => [?item?.id];
}

class ItemsAddEditErrorState extends ItemsAddEditState {
  final String message;
  const ItemsAddEditErrorState({this.message = "Some error occurred"});
  @override
  List<Object> get props => [message];
}

