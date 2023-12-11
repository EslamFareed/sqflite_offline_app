import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Database db;
  _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'todo.db');

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE todo (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT, done INTEGER)');
      },
    );
  }

  @override
  void initState() {
    _initDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var id = await db.insert(
                  'todo',
                  {
                    "id": 3,
                    "title": "Title",
                    "body": "Body",
                    "done": 1,
                  },
                );

                print(id);
              },
              child: Text("Insert"),
            ),
            ElevatedButton(
              onPressed: () async {
                await db.update(
                  'todo',
                  {
                    "title": "first todo",
                    "body": "First Desc",
                    "done": 0,
                  },
                  where: 'id = ?',
                  whereArgs: [1],
                );
              },
              child: Text("Update"),
            ),
            ElevatedButton(
              onPressed: () async {
                await db.delete(
                  'todo',
                  where: 'id = ?',
                  whereArgs: [3],
                );
              },
              child: Text("Delete"),
            ),
            ElevatedButton(
              onPressed: () async {
                var list = await db.query(
                  'todo',
                  // where: 'id = ? AND done = ?',
                  // whereArgs: [1, 1],
                );
                print(list);
              },
              child: Text("Get"),
            ),
          ],
        ),
      ),
    );
  }
}
