import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          surface: Colors.blueGrey,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[850],
        shadowColor: Colors.white24,
      ),
      themeMode: ThemeMode.system,
      home: const TodoHome(),
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
  int? _editingTaskId; // To keep track of the task being edited

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Map<String, dynamic>> tasks = await _dbHelper.getTasks();
    setState(() {
      _tasks
        ..clear()
        ..addAll(tasks.map((task) => {
              'id': task['id'],
              'task': task['task'],
              'completed': (task['completed'] as int) == 1,
            }))
        ..sort((a, b) => a['completed'] ? 1 : -1);
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
    _loadTasks();
  }

  void _deleteTask(int index) async {
    int taskId = _tasks[index]['id'];
    await _dbHelper.deleteTask(taskId);
    setState(() {
      _tasks.removeAt(index);
      if (_editingTaskId == taskId) {
        _editingTaskId =
            null; // Clear the editing task ID when the task is deleted
      }
    });
  }

  void _updateTask() async {
    if (_controller.text.isNotEmpty && _editingTaskId != null) {
      // Ensure the task still exists in the list
      final taskIndex =
          _tasks.indexWhere((task) => task['id'] == _editingTaskId);
      if (taskIndex != -1) {
        await _dbHelper.updateTaskStatus(_editingTaskId!,
            true); // Update as completed or not, can be expanded
        setState(() {
          // Update task in the list and reset controller
          _tasks[taskIndex]['task'] = _controller.text;
          _editingTaskId = null;
        });
        _controller.clear();
      } else {
        // Task was deleted, so clear editing state
        _editingTaskId = null;
        _controller.clear();
      }
    }
  }

  // Handle editing a task
  void _editTask(int index) {
    setState(() {
      _editingTaskId = _tasks[index]['id'];
      _controller.text = _tasks[index]['task']; // Load task into controller
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.tealAccent[700]
            : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText:
                    _editingTaskId != null ? 'Edit task' : 'Enter a task',
                labelStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.tealAccent
                      : Colors.blue,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.tealAccent
                        : Colors.blue,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.tealAccent
                        : Colors.blue,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.greenAccent
                        : Colors.blueAccent,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _editingTaskId != null ? Icons.save : Icons.add_circle,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.tealAccent
                        : Colors.blue,
                  ),
                  onPressed: _editingTaskId != null
                      ? _updateTask
                      : () => _addTask(_controller.text),
                ),
              ),
              onSubmitted: (text) {
                if (_editingTaskId != null) {
                  _updateTask();
                } else {
                  _addTask(text);
                }
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text("No tasks yet, add some!",
                          style: TextStyle(fontSize: 16)))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[650]
                                    : Colors.white,
                            elevation: 4,
                            shadowColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white24
                                    : Colors.black87,
                            child: ListTile(
                              leading: Checkbox(
                                value: _tasks[index]['completed'],
                                onChanged: (value) => _toggleTask(index),
                                activeColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.tealAccent
                                    : Colors.blue,
                              ),
                              title: Text(
                                _tasks[index]['task'],
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: _tasks[index]['completed']
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor: _tasks[index]['completed']
                                      ? Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.tealAccent
                                          : Colors.blue
                                      : null,
                                  decorationThickness:
                                      _tasks[index]['completed'] ? 3 : 0,
                                  color: _tasks[index]['completed']
                                      ? Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.tealAccent
                                          : Colors.blue
                                      : null,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.tealAccent
                                            : Colors.blue),
                                    onPressed: () => _editTask(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () => _deleteTask(index),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

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
