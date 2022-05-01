import 'package:flutter/material.dart';
import 'package:tasks/models/item.dart';
import 'package:tasks/repositories/item_repository.dart';
import 'package:tasks/screens/home_screen.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var _taskTitleController = TextEditingController();
  var _repository = Repository();
  var _itemsList = <Item>[];
  static const String routeName = '/tasks_screen';

  @override
  void initState() {
    super.initState();
    getAllItems();
  }

  getAllItems() async {
    _itemsList = <Item>[];
    var items = await _repository.readAllItems();
    items.forEach((element) {
      setState(() {
        var itemModel = Item(
            id: element.id,
            title: element.title,
            userId: element.userId,
            completed: element.completed);
        _itemsList.add(itemModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(HomeScreen.routeName),
          ),
          title: Text('Tasks'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    'Tasks from local database',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _itemsList.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _itemCard(context, _itemsList[index]);
                    }),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showFormdialog(context);
          },
          child: const Icon(Icons.add),
        ));
  }

  Padding _itemCard(BuildContext context, Item item) {
    return Padding(
      padding: EdgeInsets.only(left: 4, top: 4, right: 4),
      child: Card(
        elevation: 8.0,
        child: ListTile(
          title: Row(
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
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    var _updatedItem =
                        item.copyWith(title: 'Edit Text local DataBase');
                    _repository.update(_updatedItem);
                    getAllItems();
                  }),
              IconButton(
                onPressed: () {
                  _repository.delete(item.id!);
                  getAllItems();
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }

  _showFormdialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('Cancel')),
            TextButton(
                onPressed: () async {
                  var allItems = await _repository.readAllItems();
                  var item = Item(
                    title: _taskTitleController.value.text,
                    completed: false,
                    userId: 1,
                  );
                  //Create New Item in Db
                  await _repository.create(item);
                  //then get items from db
                  getAllItems();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text('Save'))
          ],
          title: Text('Tasks Form'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _taskTitleController,
                  decoration: InputDecoration(
                      hintText: 'Write a Title', labelText: 'title'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
