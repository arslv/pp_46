import 'package:hive/hive.dart';

part 'idea_entity.g.dart';

@HiveType(typeId: 1)
class Idea extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String text;
  @HiveField(2)
  DateTime dateTime;
  @HiveField(3)
  String base64Image;
  @HiveField(4)
  bool isLiked;
  @HiveField(5)
  String category;

  Idea(
      {required this.name,
      required this.text,
      required this.dateTime,
      required this.base64Image,
      required this.isLiked,
      required this.category});

  Idea copyWith(
          {String? name,
          String? text,
          DateTime? dateTime,
          String? base64Image,
          bool? isLiked,
          String? category}) =>
      Idea(
        name: name ?? this.name,
        text: text ?? this.text,
        dateTime: dateTime ?? this.dateTime,
        base64Image: base64Image ?? this.base64Image,
        isLiked: isLiked ?? this.isLiked,
        category: category ?? this.category,
      );
}
