part of 'items_add_edit_bloc.dart';

abstract class ItemsAddEditEvent extends Equatable {
  const ItemsAddEditEvent();
}

class ItemsAddEditOpenedEvent extends ItemsAddEditEvent {
  final int? itemid;

  const ItemsAddEditOpenedEvent({this.itemid});

  @override
  List<Object> get props => [];
}

class SubmitFormEvent extends ItemsAddEditEvent {
  final Map<String, dynamic>? details;
  final File? file;

  const SubmitFormEvent({this.details, this.file});

  @override
  List<Object> get props => [details?["id"]];
}

