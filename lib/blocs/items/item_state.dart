part of 'item_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();
}

class ItemInitial extends ItemState {
  @override
  List<Object> get props => [];
}

class ItemLoading extends ItemInitial{}
class ItemLoaded extends ItemInitial{
  final List<Item> items;
  ItemLoaded({this.items = const[]});

  @override
  List<Object> get props=>[items];

}
