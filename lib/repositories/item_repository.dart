import 'package:tasks/db/database_helper.dart';

import '../models/item.dart';

class Repository {
  DatabaseConnection _databaseConnection = DatabaseConnection.instance;

  //INSERT NEW Item
  Future<Item> create(Item item) async {
    final db = await _databaseConnection.database;
    final id = await db.insert(tableItems, item.toJson());
    return item.copyWith(id: id);
  }

  //Get Item from dataBase
  Future<Item?> readItem(int id) async {
    final db = await _databaseConnection.database;

    final maps = await db.query(
      tableItems,
      columns: ItemFields.values,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Item(
          id: (maps.first['id'] as int).toInt(),
          title: maps.first['title'].toString(),
          userId: (maps.first['userId'] as int).toInt(),
          completed: maps.first['completed'] == 'false' ? false : true);
    } else {
      return null;
      //throw Exception('ID $id not found');
    }
  }

  //Get All Items from dataBase
  Future<List<Item>> readAllItems() async {
    final db = await _databaseConnection.database;
    const orderBy = '${ItemFields.id} ASC';
    final result = await db.query(tableItems, orderBy: orderBy);
    var _items = <Item>[];
    for (var value in result) {
      var itemModel = Item(
          id: (value['id'] as int).toInt(),
          title: value['title'].toString(),
          userId: (value['userId'] as int).toInt(),
          completed: value['completed'] == 'false' ? false : true);
      _items.add(itemModel);
    }
    return _items;
  }

  //Update Item
  Future<int> update(Item item) async {
    final db = await _databaseConnection.database;
    print(item.title);

    return db.update(
      tableItems,
      item.toJson(),
      where: '${ItemFields.id} = ?',
      whereArgs: [item.id],
    );
  }

  //delete Item from db
  Future<int> delete(int id) async {
    final db = await _databaseConnection.database;

    return await db.delete(
      tableItems,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await _databaseConnection.database;
    db.close();
  }
}

abstract class ItemsRepository {
  Future<List<Item>> readAllItems();
  Future<Item?> readItem(int id);
  Future<int?> update(Item item);
  Future<int?> create(Item item);
  Future<int?> delete(int id);
}

class ItemsRepositoryImpl extends ItemsRepository {
  Repository _repository = Repository();

  @override
  Future<int?> create(Item item) async {
    Item _item = await _repository.create(item);
    return _item.id!;
  }

  @override
  Future<int?> delete(int id) async {
    int _id = await _repository.delete(id);
    return _id;
  }

  @override
  Future<List<Item>> readAllItems() async {
    List<Item> items = await _repository.readAllItems();
    return items;
  }

  @override
  Future<Item?> readItem(int id) async {
    Item? item = await _repository.readItem(id);
    return item;
  }

  @override
  Future<int?> update(Item item) async {
    int id = await _repository.update(item);
    return id;
  }
}
