import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../grid_item.dart';

part 'items_grid_event.dart';
part 'items_grid_state.dart';


class ItemsGridBloc extends Bloc<ItemsGridEvent, ItemsGridState> {

  ItemsGridBloc() : super(ItemsGridLoadingState()) {
    on<ItemsGridStartedEvent>(_onStart);
    // on<ClickOnItemEvent>(_onClick);
  }

  _onStart(ItemsGridStartedEvent event, Emitter<ItemsGridState> emit) {
    /// fetch the data here
    emit(const ItemsGridLoadedState(items: []));
  }

  // AddTodo event handler which emits TodoAdded state
  // _addTodo(AddTodoEvent event, Emitter<TodoState> emit) {
  //   final state = this.state;
  //
  //   if (state is TodoListLoadedState) {
  //     emit(TodoListLoadedState(items: [...state.items, event.todoObj]));
  //   }
  // }

  // // RemoveTodo event handler which emits TodoDeleted state
  // _removeTodo(RemoveTodoEvent event, Emitter<TodoState> emit) {
  //   final state = this.state;
  //
  //   if (state is TodoListLoadedState) {
  //     List<Item> items = state.items;
  //     items.removeWhere((element) => element.id == event.todoObj.id);
  //
  //     emit(TodoListLoadedState(items: items));
  //   }
  // }

  // _toggleTodo(ToggleTodoEvent event, Emitter<TodoState> emit) {
  //   final state = this.state;
  //
  //   if (state is TodoListLoadedState) {
  //
  //     List<Item> items = List.from(state.items);
  //     int indexToChange = items.indexWhere((element) => element.id == event.todoObj.id);
  //
  //     // If the element is found, we create a copy of the element with the `completed` field toggled.
  //     if (indexToChange != -1) {
  //       Item itemToChange = items[indexToChange];
  //       Item updatedItem = Item(description: itemToChange.description, completed: !itemToChange.completed);
  //
  //       items[indexToChange] = updatedItem;
  //     }
  //
  //     emit(TodoListLoadedState(items: [...items]));
  //   }
  // }
}