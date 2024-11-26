import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/model/task.dart';

class DatabaseHelper {
  late Database? _db;
  static final DatabaseHelper instance = DatabaseHelper._instance();

  DatabaseHelper._instance();

  Future<Database> _initDb() async {
    return await openDatabase(join(await getDatabasesPath(), "tasks.db"),
        version: 1, onCreate: _onCreate);
  }

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE 
        tasks (id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT , 
        creationDate TEXT NOT NULL,
        finishDate TEXT,
        isDone INTEGER NOT NULL,
        isDisable INTEGER NOT NULL
           )''');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    return await _db!.query("tasks");
  }

  Future<int> insertTask(Task task) async {
    return await _db!.insert("tasks", task.toMap());
  }

  Future<int> updateTask(id, int isDone) async {
    return await _db!
        .update("tasks", {"isDone": isDone}, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    return await _db!.delete("tasks", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAllTasks() async {
    return await _db!.delete("tasks");
  }

  Future<int> getCount() async {
    List<Map<String, dynamic>> x =
        await _db!.rawQuery("SELECT COUNT (*) from tasks");
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

  Future<List<Task>> getTasks() async {
    var taskMapList = await getTaskMapList();
    int count = taskMapList.length;
    List<Task> taskList = <Task>[];
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMap(taskMapList[i]));
    }
    return taskList;
  }

  Future<List<Task>> getPendingTasks() async {
    var taskMapList = await _db!.query("tasks", where: "isDone = 0");
    int count = taskMapList.length;
    List<Task> taskList = <Task>[];
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMap(taskMapList[i]));
    }
    return taskList;
  }
}
