import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks/models/item.dart';
import 'package:tasks/repositories/item_repository.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc({required this.itemRepository})
      : assert(ItemsRepository != null),
        super(ItemLoading()) {
    on<LoadItems>(_onLoadItems);
    on<AddToItems>(_onAddToItems);
    on<DeleteItems>(_onDeleteItems);
    on<UpdateItems>(_onUpdateItems);
    on<RefreshItems>(_onRefresshItems);
  }

  final ItemsRepository itemRepository;

  void _onLoadItems(LoadItems event, Emitter<ItemState> emit) async {
    for (int i = 0; i < event.items.length; i++) {
      await itemRepository.create(event.items[i]);
    }
    emit(ItemLoaded(items: event.items));
  }

  void _onRefresshItems(RefreshItems event, Emitter<ItemState> emit) async {
    //print('REFRESH');
    for (int i = 0; i < event.items.length; i++) {
      if (await itemRepository.readItem(event.items[i].id!) == null) {
        await itemRepository.create(event.items[i]);
      } else {
        await itemRepository.update(event.items[i]);
      }
    }
    emit(ItemLoaded(items: event.items));
  }

  void _onAddToItems(AddToItems event, Emitter<ItemState> emit) async {
    final state = this.state;
    if (state is ItemLoaded) {
      var _itemID = await itemRepository.create(event.item);
      emit(
        ItemLoaded(
          items: List.from(state.items)..add(event.item),
        ),
      );
    }
  }

  void _onDeleteItems(DeleteItems event, Emitter<ItemState> emit) async {
    final state = this.state;
    if (state is ItemLoaded) {
      //print('_onDeleteItems FROM API');
      var _itemID = await itemRepository.delete(event.item.id!);
      //print('_itemId' + _itemID.toString());
      //Delete from API (Bloc)
      List<Item> items = state.items.where((element) {
        return element.id != event.item.id; //_itemID.toString();
      }).toList();
      emit(
        ItemLoaded(items: items),
      );
    }
  }

  void _onUpdateItems(UpdateItems event, Emitter<ItemState> emit) async {
    final state = this.state;
    if (state is ItemLoaded) {
      var _itemID = await itemRepository.update(event.item);
      List<Item> items = (state.items.map((item) {
        return item.id == event.item.id ? event.item : item;
      })).toList();
      emit(ItemLoaded(items: items));
    }
  }
}
