import 'package:hive_flutter/hive_flutter.dart';

class TodoDB {
  List toDoList = [];

  // ref box
  final _myBox = Hive.box('mybox');

  // create initial data
  void createInitialData() {
    toDoList = [
      ['Make tutorial', false],
      ['Learn flutter', false],
      ['Earn money', false],
    ];
  }

  // load the data frin db

  void loadData() {
    toDoList = _myBox.get('TODOLIST');
  }

  // update db
  void updateDb() {
    _myBox.put('TODOLIST', toDoList);
  }
}
