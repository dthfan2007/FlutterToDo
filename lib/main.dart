import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoHome(),
    );
  }
}

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Map<String, dynamic>> tasks = await _dbHelper.getTasks();
    setState(() {
      _tasks.clear();
      _tasks.addAll(tasks.map((task) => {
            'id': task['id'],
            'task': task['task'],
            'completed':
                (task['completed'] as int) == 1, // ✅ Convert int to bool
          }));
    });
  }

  void _addTask(String task) async {
    if (task.isNotEmpty) {
      int id = await _dbHelper.insertTask({'task': task, 'completed': 0});
      setState(() {
        _tasks.add({'id': id, 'task': task, 'completed': false});
      });
      _controller.clear();
    }
  }

  void _toggleTask(int index) async {
    int taskId = _tasks[index]['id'];
    bool newStatus = !_tasks[index]['completed'];
    await _dbHelper.updateTaskStatus(taskId, newStatus);
    setState(() {
      _tasks[index]['completed'] = newStatus;
    });
  }

  void _deleteTask(int index) async {
    int taskId = _tasks[index]['id'];
    await _dbHelper.deleteTask(taskId);
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do App')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter a task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTask(_controller.text),
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _tasks[index]['completed'],
                    onChanged: (value) => _toggleTask(index),
                  ),
                  title: Text(
                    _tasks[index]['task'],
                    style: TextStyle(
                      decoration: _tasks[index]['completed']
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Database Helper Class
class DatabaseHelper {
  static const String tableName = 'tasks';

  Future<Database> _getDatabase() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task TEXT,
            completed INTEGER
          )
        ''');
      },
    );
  }

  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await _getDatabase();
    return await db.insert(tableName, task);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await _getDatabase();
    return await db.query(tableName);
  }

  Future<int> updateTaskStatus(int id, bool completed) async {
    final db = await _getDatabase();
    return await db.update(
      tableName,
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await _getDatabase();
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
