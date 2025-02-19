/// main.dart
///
/// Author: Matteo Cipriani
/// Created: 2025-02-18
/// Description: This file contains the actual todo list screen.
///
/// Version: Beta 2.1.1
/// Latest Change: Added Localization to texts

//# region [Section 1] Imports
// MARK: Imports
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//# endregion
class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];
  late DatabaseHelper _dbHelper;
  int? _editingTaskId;
  //# region [Section 2] Local functions
  // MARK: Functions
  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadTasks();
  }

  // Load all tasks and display them, non-completed tasks at the top
  Future<void> _loadTasks() async {
    List<Map<String, dynamic>> tasks = await _dbHelper.getTasks();
    // Update screen
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

  // Add a new task
  void _addTask(String task) async {
    if (task.isNotEmpty) {
      int id = await _dbHelper.insertTask({'task': task, 'completed': 0});
      // Update screen
      setState(() {
        _tasks.add({'id': id, 'task': task, 'completed': false});
      });
      _controller.clear();
    }
  }

  // Toggle the completion status of a task
  void _toggleTask(int index) async {
    int taskId = _tasks[index]['id'];
    bool newStatus = !_tasks[index]['completed'];
    await _dbHelper.updateTaskStatus(taskId, newStatus);
    _loadTasks();
  }

  // Delete a task
  void _deleteTask(int index) async {
    int taskId = _tasks[index]['id'];
    await _dbHelper.deleteTask(taskId);
    // Update screen
    setState(() {
      _tasks.removeAt(index);
      if (_editingTaskId == taskId) {
        _editingTaskId = null;
      }
    });
  }

  // Update a task (after editing)
  void _updateTask() async {
    if (_controller.text.isNotEmpty && _editingTaskId != null) {
      final taskIndex =
          _tasks.indexWhere((task) => task['id'] == _editingTaskId);
      if (taskIndex != -1) {
        await _dbHelper.updateTaskStatus(_editingTaskId!, true);
        // Update screen
        setState(() {
          _tasks[taskIndex]['task'] = _controller.text;
          _editingTaskId = null;
        });
        _controller.clear();
      } else {
        _editingTaskId = null;
        _controller.clear();
      }
    }
  }

  // Edit a task
  void _editTask(int index) {
    setState(() {
      _editingTaskId = _tasks[index]['id'];
      _controller.text = _tasks[index]['task'];
    });
  }

  //# endregion
  //# region [Section 3] App Widget
  // MARK: Build Widget
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // MARK: App Bar
      // Title bar
      appBar: AppBar(
        title: Text(l10n.todoList,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.tealAccent[700]
            : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            //# region [Section 4] Input Field
            // MARK: Input Field
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText:
                    _editingTaskId != null ? l10n.editTask : l10n.enterTask,
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
            //# endregion
            //# region [Section 5] Task List
            // MARK: Task List
            const SizedBox(height: 12),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: Text(l10n.noTasks,
                          style: const TextStyle(fontSize: 16)),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Theme.of(context).brightness == Brightness.dark
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
                            //# region [Section 6] Icons
                            // MARK: Icons
                            // Icons on the right side of every task to edit / delete it
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
                            //# endregion
                          ),
                        );
                      },
                    ),
            ),
            //# endregion
          ],
        ),
      ),
    );
  }
  //# endregion
}

// region [Section 7] Database
// MARK: Database
// Database Functions
class DatabaseHelper {
  static const String tableName = 'tasks';

  // Load database, create it if it doesn't exist
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

  // Insert a new task into the database
  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await _getDatabase();
    return await db.insert(tableName, task);
  }

  // Load all tasks from the database
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await _getDatabase();
    return await db.query(tableName);
  }

  // Update a task's status in the database
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
//# endregion
