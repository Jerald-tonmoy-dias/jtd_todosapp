import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jtd_todosapp/data/database.dart';
import 'package:jtd_todosapp/util/dialog_box.dart';
import 'package:jtd_todosapp/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// ref the hive box
  final _myBox = Hive.box('mybox');
  TodoDB db = TodoDB();

  @override
  void initState() {
    // IF LOADS 1ST TIME
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      // there already exiest data
      db.loadData();
    }
    super.initState();
  }

// text controller
  final _controller = TextEditingController();

// list of todo task

  // List toDoList = [
  //   ['Make tutorial', false],
  //   ['Learn flutter', false],
  //   ['Earn money', false],
  // ];

// handle checkbox function
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDb();
  }

// save New Task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDb();
  }

// createNewTask
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // deleteTask
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "JTD TODO",
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: () => deleteTask(index),
          );
        },
      ),
    );
  }
}
