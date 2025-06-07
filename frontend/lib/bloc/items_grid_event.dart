part of 'items_grid_bloc.dart';

abstract class ItemsGridEvent extends Equatable {
  const ItemsGridEvent();
}

// Event to kick start the todo list event
class ItemsGridStartedEvent extends ItemsGridEvent {
  @override
  List<Object> get props => [];
}

class ClickOnItemEvent extends ItemsGridEvent {
  final todoObj;

  const ClickOnItemEvent(this.todoObj);

  @override
  List<Object> get props => [todoObj];
}

