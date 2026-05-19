import 'package:hive/hive.dart';
part 'data_model.g.dart'; 

@HiveType(typeId: 0) 
class DataModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String released;

  @HiveField(3)
  final String backgroundimage;


  DataModel({
    required this.id,
    required this.name,
    required this.released,
    required this.backgroundimage,
  });
}