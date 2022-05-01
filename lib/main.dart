import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/blocs/items/item_bloc.dart';
import 'package:tasks/config/app_router.dart';
import 'package:tasks/models/item.dart';
import 'package:tasks/repositories/item_repository.dart';
import 'package:tasks/screens/home_screen.dart';
import 'package:tasks/services/item_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //init Database
  ItemsRepository itemRepository = ItemsRepositoryImpl();
  ItemsService itemService = ItemsService();
  var _items = await itemService.getData();
  var items = _items as List;
  var testList = List<Item>.from(items.map((i) => Item.fromJson(i)));
  //Get only items which userId equals 1
  var finalList = testList.where((element) {
    return element.userId == 1;
  }).toList();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) => ItemBloc(itemRepository: itemRepository)
          ..add(LoadItems(items: finalList))),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorObservers: [RouteGenerator()],
    );
  }
}
