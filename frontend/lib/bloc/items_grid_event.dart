part of 'items_grid_bloc.dart';

abstract class ItemsGridEvent extends Equatable {
  const ItemsGridEvent();
}

class ItemsGridStartedEvent extends ItemsGridEvent {
  @override
  List<Object> get props => [];
}

class ClickOnItemEvent extends ItemsGridEvent {
  final itemid;

  const ClickOnItemEvent({this.itemid});

  @override
  List<Object> get props => [itemid];
}

class ChangeSearchStringEvent extends ItemsGridEvent {
  final currSearchStr;

  const ChangeSearchStringEvent({this.currSearchStr = ""});

  @override
  List<Object> get props => [currSearchStr];

}