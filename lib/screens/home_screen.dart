import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/blocs/items/item_bloc.dart';
import 'package:tasks/screens/drawer_navigation.dart';
import 'package:tasks/services/item_service.dart';

import '../models/item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var itemService = ItemsService();
                var _items = await itemService.getData() as List;
                var testList =
                    List<Item>.from(_items.map((i) => Item.fromJson(i)));
                //Get only items which userId equals 1
                var finalList = testList.where((element) {
                  return element.userId == 1;
                }).toList();

                BlocProvider.of<ItemBloc>(context)
                  ..add(RefreshItems(items: finalList));
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
      drawer: const DrawerNavigation(),
      body: _items('Home - Tasks From API'),
    );
  }

  BlocConsumer<ItemBloc, ItemState> _items(String title) {
    return BlocConsumer<ItemBloc, ItemState>(listener: (context, state) {
      if (state is ItemLoaded) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('There are ${state.items.length} Items'),
        ));
      }
    }, builder: (context, state) {
      if (state is ItemLoading) {
        //print('STATE' + state.toString());
        return Center(child: const CircularProgressIndicator());
      }
      if (state is ItemLoaded) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: state.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _itemCard(context, state.items[index]);
                    }),
              ],
            ),
            flex: 1,
          ),
        );
      } else {
        return const Text('Something Wen Wrong!!');
      }
    });
  }

  Card _itemCard(BuildContext context, Item item) {
    return Card(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '#${item.id}: ${item.title}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              flex: 1,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      context.read<ItemBloc>().add(
                            UpdateItems(
                                item: item.copyWith(title: 'Edit Text')),
                          );
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      context.read<ItemBloc>().add(
                            DeleteItems(item: item),
                          );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
