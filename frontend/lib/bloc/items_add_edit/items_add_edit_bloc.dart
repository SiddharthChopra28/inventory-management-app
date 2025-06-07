import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../grid_item.dart';

part 'items_add_edit_event.dart';
part 'items_add_edit_state.dart';


class ItemsAddEditBloc extends Bloc<ItemsAddEditEvent, ItemsAddEditState> {

  ItemsAddEditBloc() : super(ItemsAddEditLoadingState()) {
    on<ItemsAddEditOpenedEvent>(_onStart);
    on<SubmitFormEvent>(_onSubmit);
  }

  Future<void> _onStart(ItemsAddEditOpenedEvent event, Emitter<ItemsAddEditState> emit) async {
    // fetch the data here
    emit(const ItemsAddEditLoadedState()); // pass in an Item(...) here
  }

  _onSubmit(SubmitFormEvent event, Emitter<ItemsAddEditState> emit){
    emit(ItemsAddEditLoadingState());
    // submit the data
    // fetch new data
    emit(const ItemsAddEditLoadedState());  // pass in an Item(...) here
  }
}