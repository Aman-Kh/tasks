import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/blocs/items/item_bloc.dart';
import 'package:tasks/screens/drawer_navigation.dart';

import '../models/item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home_screen';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
          ],
          centerTitle: true,
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: const DrawerNavigation(),
        body: _items('Home - Tasks From API'),
      ),
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
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
            ),
          ),
        );
      } else {
        return const Text('Something Wen Wrong!!');
      }
    });
  }

  Card _itemCard(BuildContext context, Item item) {
    return Card(
      margin: const EdgeInsets.all(3.0),
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
