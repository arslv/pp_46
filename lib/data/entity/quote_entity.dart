import 'package:hive/hive.dart';

part 'quote_entity.g.dart';

@HiveType(typeId: 2)
class QuoteEntity extends HiveObject{
  @HiveField(0)
  final String quote;
  @HiveField(1)
  final String author;
  @HiveField(2)
  bool isLiked;
  @HiveField(3)
  String category;

  QuoteEntity({required this.quote, required this.author, required this.isLiked, required this.category});
}