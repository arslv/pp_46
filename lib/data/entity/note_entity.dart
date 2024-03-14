import 'package:hive/hive.dart';

part 'note_entity.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String text;
  @HiveField(2)
  DateTime dateTime;

  Note({required this.name, required this.text, required this.dateTime});

  Note copyWith({String? name, String? text, DateTime? dateTime}) => Note(
        name: name ?? this.name,
        text: text ?? this.text,
        dateTime: dateTime ?? this.dateTime,
      );
}
