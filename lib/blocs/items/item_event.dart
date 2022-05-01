part of 'item_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class LoadItems extends ItemEvent {
  final List<Item> items;

  const LoadItems({required this.items});

  @override
  List<Object?> get props => [items];
}

class AddToItems extends ItemEvent {
  final Item item;
  const AddToItems({required this.item});

  @override
  List<Object?> get props => [item];
}

class UpdateItems extends ItemEvent {
  final Item item;
  const UpdateItems({required this.item});

  @override
  List<Object?> get props => [item];
}

class DeleteItems extends ItemEvent {
  final Item item;
  const DeleteItems({required this.item});

  @override
  List<Object?> get props => [item];
}

class RefreshItems extends ItemEvent {
  final List<Item> items;

  const RefreshItems({required this.items});

  @override
  List<Object?> get props => [items];
}
