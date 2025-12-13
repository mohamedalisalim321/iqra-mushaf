import 'package:isar/isar.dart';

part 'reciter.g.dart';

@collection
class Reciter {
  Id id = Isar.autoIncrement;
  late String name;
  late String engName;

  late String identifier;
  late int bitrate;
}