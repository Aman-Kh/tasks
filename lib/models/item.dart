import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

const String tableItems = 'items';

class ItemFields {
  static final List<String> values = [id, userId, title, completed];

  static const String id = 'id';
  static const String userId = 'userId';
  static const String title = 'title';
  static const String completed = 'completed';
}

class Item extends Equatable {
  final int? id;
  final int userId;
  final bool completed;
  final String title;

  const Item(
      {this.id,
      required this.title,
      required this.userId,
      required this.completed});

  @override
  List<Object?> get props => [id, title, userId, completed];

  //Modify Items
  Item copyWith({int? id, String? title, int? userId, bool? completed}) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      completed: completed ?? this.completed,
    );
  }

  factory Item.fromJson(Map<String, dynamic>? json) {
    //print("json :" + json.toString());
    if (json != null) {
      return Item(
          id: (json['id'] as int),
          title: json['title'] ?? '',
          completed: (json['completed']),
          userId: (json['userId'] as int));
    }
    return const Item(id: 0, userId: 0, title: '', completed: false);
  }

  Map<String, dynamic> toJson() => {
        ItemFields.id: id,
        ItemFields.userId: userId,
        ItemFields.title: title,
        ItemFields.completed: completed,
      };
}
