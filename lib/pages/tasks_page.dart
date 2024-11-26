import 'package:flutter/material.dart';
import 'package:todolist/utils/database_helper.dart';
import 'package:todolist/model/task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  var _tasks = [];
  bool onlyPending = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabaseAndTasks();
  }

  void _initializeDatabaseAndTasks() async {
    await _databaseHelper.database;
    getTasks();
  }

  void getTasks() async {
    if (onlyPending) {
      _tasks = await _databaseHelper.getPendingTasks();
    } else {
      _tasks = await _databaseHelper.getTasks();
    }
    return setState(() {});
  }

  void _deleteTasks() async {
    int result = await _databaseHelper.deleteAllTasks();
    if (result != 0) {
      _showSnackBar(context, "All Tasks Deleted Successfully");
      setState(() {
        getTasks();
      });
    }
  }

  _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('todolist_',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            descriptionController.clear();
            titleController.clear();
            showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return AlertDialog(
                      title: const Text("Add new task"),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleController,
                              decoration:
                                  const InputDecoration(hintText: "Title"),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                  hintText: "Description"),
                            )
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (titleController.text.isNotEmpty) {
                              Task task = Task(titleController.text,
                                  descriptionController.text);
                              _databaseHelper.insertTask(task);
                              Navigator.pop(context);
                              setState(() {
                                getTasks();
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return AlertDialog(
                                      title: const Text("Error"),
                                      content: const Text(
                                          "Title is required to add a task"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Ok"),
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                          child: const Text("Add"),
                        )
                      ]);
                });
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Only pending",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Switch(
                        value: onlyPending,
                        onChanged: (bool value) {
                          setState(() {
                            onlyPending = value;
                            getTasks();
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (BuildContext bc, int index) {
                    var task = _tasks[index];
                    return FractionallySizedBox(
                      widthFactor: 0.95,
                      child: Dismissible(
                        key: Key(task.id),
                        onDismissed: (direction) async {
                          await _databaseHelper.deleteTask(int.parse(task.id));
                          setState(() {
                            _tasks.removeAt(index);
                          });
                        },
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            trailing: Checkbox(
                              value: task.isDone == 1,
                              onChanged: (bool? value) {
                                _databaseHelper.updateTask(
                                    task.id, value! ? 1 : 0);
                                setState(() {
                                  getTasks();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
